-- Java Setup with auto SDK detection, which-key, and LWJGL/GLFW static imports
local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
	vim.notify("JDTLS not found, install with `:LspInstall jdtls`")
	return
end

local which_key_ok, which_key = pcall(require, "which-key")
if not which_key_ok then
	vim.notify("which-key not found")
	return
end

-- Import default LSP opts
local lsp_opts_ok, lsp_opts = pcall(require, "plugins.lsp.opts")
if not lsp_opts_ok then
	vim.notify("Failed to load lsp.opts")
	return
end

local jdtls_dir = vim.fn.stdpath("data") .. "/mason/share/jdtls"
local config_dir = vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_linux"

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name
os.execute("mkdir -p " .. workspace_dir)

-- Debug & test bundles
local bundles = {
	vim.fn.glob(vim.fn.stdpath("data") .. "/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/share/java-test/*.jar", 1), "\n"))

-- Extended client capabilities
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

-- Auto-detect JDK
local function detect_java_cmd()
	if vim.fn.executable("./gradlew") == 1 then
		local gradle_java = vim.fn.systemlist('./gradlew -q javaToolchains | grep "JDK"')[1]
		if gradle_java and gradle_java ~= "" then
			return gradle_java
		end
	end

	if vim.fn.executable("./mvnw") == 1 then
		local mvn_java = vim.fn.systemlist('./mvnw -v | grep "Java home" | awk -F ": " \'{print $2}\'')[1]
		if mvn_java and mvn_java ~= "" then
			return mvn_java .. "/bin/java"
		end
	end

	if os.getenv("JAVA_HOME") then
		return os.getenv("JAVA_HOME") .. "/bin/java"
	end

	return "java"
end

local java_cmd = detect_java_cmd()

-- Lombok auto-detection
local function find_lombok()
	local paths = {
		vim.fn.stdpath("data") .. "/mason/share/jdtls/lombok.jar",
		vim.fn.stdpath("data") .. "/mason/packages/lombok-nightly/lombok.jar",
	}

	for _, path in ipairs(paths) do
		if vim.fn.filereadable(path) == 1 then
			return path
		end
	end
	vim.notify("⚠️ Lombok jar not found", vim.log.levels.WARN)
	return nil
end

local lombok_path = find_lombok()

-- JDTLS launcher detection
local function find_launcher()
	local candidates = {
		jdtls_dir .. "/plugins/org.eclipse.equinox.launcher.jar",
		jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar",
		vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher.jar",
		vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar",
	}

	for _, path in ipairs(candidates) do
		local found = vim.fn.glob(path, true)
		if found ~= "" then
			return found
		end
	end

	vim.notify("❌ Could not locate org.eclipse.equinox.launcher*.jar", vim.log.levels.ERROR)
	return nil
end

local launcher_path = find_launcher()
if not launcher_path then
	return
end

-- Build cmd
local cmd = {
	java_cmd,
	"-Declipse.application=org.eclipse.jdt.ls.core.id1",
	"-Dosgi.bundles.defaultStartLevel=4",
	"-Declipse.product=org.eclipse.jdt.ls.core.product",
	"-Dlog.protocol=true",
	"-Dlog.level=ALL",
	"-Xmx1g",
	"--add-modules=ALL-SYSTEM",
	"--add-opens",
	"java.base/java.util=ALL-UNNAMED",
	"--add-opens",
	"java.base/java.lang=ALL-UNNAMED",
	"-jar",
	launcher_path,
	"-configuration",
	config_dir,
	"-data",
	workspace_dir,
}

if lombok_path then
	table.insert(cmd, 6, "-javaagent:" .. lombok_path)
end

-- Config
local config = {
	cmd = cmd,
	root_dir = require("jdtls.setup").find_root({ ".project", ".git", "mvnw", "pom.xml", "build.gradle" }),
	settings = {
		java = {
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			references = { enabled = true },
			signatureHelp = { enabled = true },

			project = { outputPath = "bin", sourcesPaths = { "src", "test" } },
			configuration = { updateBuildConfiguration = "interactive" },

			format = {
				enabled = true,
				comments = true,
				settings = {
					url = vim.fn.stdpath("config") .. "/utils/eclipse-java-google-style.xml",
					profile = "GoogleStyle",
				},
			},
		},

		completion = {
			favoriteStaticMembers = {
				-- LWJGL / GLFW
				"org.lwjgl.glfw.*",
				"org.lwjgl.glfw.GLFW.*",
				"org.lwjgl.opengl.GL.*",
				"org.lwjgl.system.MemoryUtil.*",
				"org.lwjgl.opengl.GL11.*",
				"org.lwjgl.opengl.GL13.*",
				"org.lwjgl.opengl.GL20.*",
				"org.lwjgl.glfw.Callbacks.*",
				"org.lwjgl.system.MemoryStack.*",
			},
			importOrder = { "java", "javax", "com", "org" },
		},

		extendedClientCapabilities = extendedClientCapabilities,
		sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
		import = { gradle = { enabled = true }, maven = { enabled = true } },
		codeGeneration = {
			toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
			useBlocks = true,
		},
	},

	flags = { allow_incremental_sync = true },
	capabilities = lsp_opts.capabilities,
	on_attach = lsp_opts.on_attach,
	init_options = { bundles = bundles },
}

-- On attach
config.on_attach = function(client, bufnr)
	-- DAP setup
	require("jdtls").setup_dap({ hotcodereplace = "auto" })
	local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
	if status_ok then
		jdtls_dap.setup_dap_main_class_configs()
	end

	-- which-key mappings under <leader>J
	local wk = require("which-key")
	wk.add({
		{ "<leader>Ji", ":lua require'jdtls'.organize_imports()<CR>", desc = "Organize Imports" },
		{ "<leader>Jv", ":lua require'jdtls'.extract_variable()<CR>", desc = "Extract Variable" },
		{ "<leader>Jc", ":lua require'jdtls'.extract_constant()<CR>", desc = "Extract Constant" },
		{ "<leader>Jm", ":lua require'jdtls'.extract_method(true)<CR>", desc = "Extract Method" },
	})
end

-- Start or attach
jdtls.start_or_attach(config)

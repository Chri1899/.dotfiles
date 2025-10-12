local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
	return
end

local bufnr = vim.api.nvim_get_current_buf()
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local WORKSPACE_PATH = vim.fn.stdpath("data") .. "/workspace/"
local workspace_dir = WORKSPACE_PATH .. project_name

-- Prevent double start
for _, client in ipairs(vim.lsp.get_active_clients({ name = "jdtls" })) do
	if client then
		return
	end
end

-- Paths for Mason-installed tools
local mason_data = vim.fn.stdpath("data") .. "/mason/packages/"
local java_debug_path = mason_data .. "java-debug-adapter/"
local java_test_path = mason_data .. "java-test/"
local jdtls_path = mason_data .. "jdtls/"
local lombok_path = mason_data .. "lombok-nightly/"

-- Cached bundles (debug/test jars)
local function cached_bundles()
	if vim.g._java_bundles then
		return vim.g._java_bundles
	end
	local b =
		vim.split(vim.fn.glob(java_debug_path .. "extension/server/com.microsoft.java.debug.plugin-*.jar", true), "\n")
	vim.list_extend(b, vim.split(vim.fn.glob(java_test_path .. "extension/server/*.jar", true), "\n"))
	vim.g._java_bundles = b
	return b
end

local bundles = cached_bundles()

-- Determine OS
local OS_NAME
if vim.g.os == "Darwin" then
	OS_NAME = "mac"
elseif vim.g.os == "Linux" then
	OS_NAME = "linux"
elseif vim.g.os == "Windows" then
	OS_NAME = "win"
else
	vim.notify("Unsupported OS", vim.log.levels.WARN, { title = "Jdtls" })
end

-- Root markers
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }

-- Main config
local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. lombok_path .. "lombok.jar",
		"-Xms512m",
		"-Xmx2G",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		jdtls_path .. "plugins/org.eclipse.equinox.launcher.jar",
		"-configuration",
		jdtls_path .. "config_" .. OS_NAME,
		"-data",
		workspace_dir,
	},
	root_dir = require("jdtls.setup").find_root(root_markers),
	on_attach = require("plugins.lsp.opts").on_attach,
	capabilities = require("plugins.lsp.opts").capabilities,
	init_options = { bundles = bundles },

	settings = {
		java = {
			completion = {
				favoriteStaticMembers = {
					"org.lwjgl.glfw.Callbacks.*",
					"org.lwjgl.glfw.GLFW.*",
					"org.lwjgl.opengl.GL11.*",
					"org.lwjgl.opengl.GL15.*",
					"org.lwjgl.opengl.GL20.*",
					"org.lwjgl.opengl.GL30.*",
					"org.lwjgl.system.MemoryStack.*",
					"org.lwjgl.system.MemoryUtil.*",
				},
			},
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			sources = {
				organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
			},
			project = {
				referencedLibraries = {}, -- initially empty
				ignoredResources = {
					"**/target/**",
					"**/build/**",
					"**/.gradle/**",
					"**/out/**",
				},
			},
			signatureHelp = { enabled = true },
			extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
			import = { gradle = { enabled = false }, maven = { enabled = false } },
			autobuild = { enabled = false },
		},
	},

	flags = { allow_incremental_sync = true },
}

local wk = require("which-key")

wk.add({
	-- Keymaps
	{ "<leader>ji", ":lua require'jdtls'.organize_imports()<cr>", desc = "Organize Imports" },
	{ "<leader>jv", ":lua require'jdtls'.extract_variable()<cr>", desc = "Extract Variable" },
	{ "<leader>jc", ":lua require'jdtls'.extract_constant()<cr>", desc = "Extract Constant" },
	{ "<leader>jm", "<Esc>:lua require'jdtls'.extract_method(true)<cr>", desc = "Extract Method" },
})

-- Commands
vim.cmd([[
command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
command! -buffer JdtJol lua require('jdtls').jol()
command! -buffer JdtBytecode lua require('jdtls').javap()
command! -buffer JdtJshell lua require('jdtls').jshell()
command! -buffer JavaTestCurrentClass lua require('jdtls').test_class()
command! -buffer JavaTestNearestMethod lua require('jdtls').test_nearest_method()
]])

-- Start or attach JDTLS immediately
jdtls.start_or_attach(config)

-- Async LWJGL jar loading (1 second after attach)
vim.defer_fn(function()
	local lwjgl_folder = vim.fn.getcwd() .. "/libs/lwjgl"
	local jars = {}
	if vim.fn.isdirectory(lwjgl_folder) ~= 0 then
		jars = vim.split(vim.fn.glob(lwjgl_folder .. "/*.jar", true), "\n")
	end

	if #jars > 0 then
		-- Send configuration change to JDTLS
		vim.lsp.buf_request(0, "workspace/didChangeConfiguration", {
			settings = { java = { project = { referencedLibraries = jars } } },
		})
	end
end, 1000)

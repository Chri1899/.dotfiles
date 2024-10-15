local function get_jdtls()
		-- Get the Mason Registry to gain access to downloaded binaries
		local mason_registry = require("mason-registry")
		-- Find the JDTLS package in the mason reg
		local jdtls_path = jdtls:get_install_path()
		-- Get access to the jar which runs the server
		local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
		-- Declare what operating system we are using, windows use win, mac use mac
		local SYSTEM = vim.loop.os_uname().sysname
		-- Obtain the path to config files for OS
		local config = jdtls_path .. "/config_" .. SYSTEM
		-- Obtain the path to Lomboc jar
		local lombok = jdtls_path .. "/lombok.jar"
		return launcher, config, lombok
end

local function get_bundles()
		-- Get Mason Registry
		local mason_registry = require("mason-registry")
		-- Find Java Debug Adapter package
		local java_debug = mason_registry.get_package("java-debug-adapter")
		-- Obtain full path to the dir where mason has downloaded the debug adapter
		local java_debug_path = java_debug:get_install_path()

		local bundles = {
				vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1)
		}

		-- Find the Java Testpackage
		local java_test = mason_registry.get_package("java-test")
		-- Obtain full path
		local java_test_path = java_test:get_install_path()
		vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n"))

		return bundles
end

local function get_workspace()
		-- Get the home dir
		local home = os.getenv "HOME"
		-- Declare a dir where you would like to store project infos
		local workspace_path = home .. "/Projects/workspace/"
		-- Determine Project name
		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
		-- Create workspace dir
		local workspace_dir = workspace_path .. project_name
		return workspace_dir
end

local function java_keymaps()
		-- Vim motion keymaps
		vim.keymap.set("n", "<leader>Jo", "<Cmd> lua require('jdtls').organize_imports()<CR>", { desc = "[J]ava [O]rganize Imports" })
		vim.keymap.set("n", "<leader>Jt", "<Cmd> lua require('jdtls').test_nearest_method()<CR>", { desc = "[J]ava [T]est Method under cursor" })
		vim.keymap.set("n", "<leader>JT", "<Cmd> lua require('jdtls').test_clas()<CR>", { desc = "[J]ava [T]est Class" })
		vim.keymap.set("n", "<leader>Ju", "<Cmd> JdtUpdateConfig<CR>, { desc = [J]ava [U]pdate Config" })
end

local function setup_jdtls()
		-- Get access to the jdtls plugin
		local jdtls = require "jdtls"

		-- Get the paths to the jdtls jar, os and lombok
		local launcher, os_config, lombok = get_jdtls()

		-- Get the path to hold project information
		local workspace_dir = get_workspace()

		-- Get bundles list with jars
		local budnles = get_bundles()

		-- Determine root dir of the project
		local root_dir = jdtls.setup.find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' });

		-- Tell JDTLS the features it is capable of
		local capabilities = {
				workspace = {
						configuration = true
				},
				textDocument = {
						completion = {
								snippetSupport = false
						}
				}
		}

		-- Get default exteneded client capabilities
		local extendedClientCapabilities = jdtls.extendedClientCapabilities
		-- Modify one property called resolveAdditionalTextEditsSupport
		extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
		
		-- Set the command that starts the JDTLS
		local cmd = {
				'java',
				'-Declipse.application=org.eclipse.jdt.ls.core.id1',
				'-Dosgi.bundles.defaultStartLevel=4',
				'-Declipse.product=org.eclipse.jdt.ls.core.product',
				'-Dlog.protocl=true',
				'-Dlog.level=ALL',
				'-Xmx1g',
				'--add-modules=ALL-SYSTEM',
				'--add-opens', 'java.base/java.util=ALL-UNNAMED',
				'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
				'-javaagent:' .. lombok,
				'-jar',
				launcher,
				'-configuration',
				os_config,
				'-data',
				workspace_dir
		}

		-- Configre settings in the JDTLS
		local settings = {
				java = {
						-- Enable code formatting
						format = {
								enabled = true,
								-- Use Google  Style guide
								settings = {
										url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
										profile = "GoogleStyle"
								}
						},
						-- Enable downloading archives from eclipse
						eclipse = {
								downloadSource = true
						},
						-- Enable downlaoding archives from maven
						maven = {
								downloadSources = true
						},
						-- Enable metod signature help
						signatureHelp = {
								enabled = true
						},
						--Use fernflower decompiler when usiong the javap command to decompile byte code back to java code
						contentProvider = {
								preferred = "fernflower"
						},
						-- Setup automatical package import organization onf ile save
						saveActions = {
								organizeImports = true
						},
						-- Customize completion options
						completion = {},
						sources = {
								-- How many classes from a specific package before combining them into one import
								organizeImports = {
										starThreshold = 9999,
										staticThreshold = 9999
								}
						},
						-- Howq should different pieces of code be generated
						codeGeneration = {
								-- When generating toString use a json format
								toString = {
										template= "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
								},
								-- When generating code use code blocks
								useBlocks = truie
						},
						-- If changes to the project will require the developer to update the projects configuration advise the developer before accepting the change
						configuration = {
								updateBuildConfiguration = "interactive"
						},
						-- Enable code lens in the lsp
						referencesCodeLense = {
								enabled = true
						},
						-- Enable inlay hints for parameter names
						inlayHints = {
								parameterNames = {
										enabled = "all"
								}
						}
				}
		}

		-- Create a table to pass the bundles with debug and testing jar along with the extended client capabilities to the start or attach function of JDTLS
		local init_options = {
				bundles = bundles,
				extendedCapabilities = extendedCapabilities
		}

		-- Function that will be ran once the server is attached
		local on_Attach = function(_, bufnr)
				-- Map the Java specific key mappings once the server is attached
				java_keymaps()

				-- Setup the java debug adapter
				require("jdtls.dap").setup_dap()
				require("jdtls.dap").setup_dap_main_class_configs()
				--Enable jdtls commands to be used in nvim
				require("jdtls_setup").add_commands()
				-- Refresh codelens
				vim.lsp.codelens.refresh()

				-- Setup a function that automatically runs every time a java file is saved to refresh the code lense
				vim.api.nvim_create_autocmd("BufWritePost", {
						pattern = { "*.java" },
						callback = function()
								local _, _ = pcall(vim.lsp.codelens.refresh)
						end
				})
		end

		-- Create the config table for the start or attach function
		local config = {
				cmd  = cmd,
				root_dir = root_dir,
				settings = settings,
				init_options = init_options,
				on_attach = on_attach
		}

		-- Start the jdtls
		require("jdtls").start_or_attach(config)		
end

return {
		setup_jdtls = setup_jdtls,
}

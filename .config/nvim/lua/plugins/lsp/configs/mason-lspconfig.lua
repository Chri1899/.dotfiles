return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "williamboman/mason.nvim" },
	config = function()
		local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
		local ok_opts, opts = pcall(require, "plugins.lsp.opts")
		if not (ok_mason and ok_opts) then
			return
		end

		mason_lspconfig.setup({
			ensure_installed = {
				"tsserver", -- Changed from "ts_ls" to "tsserver"
				"tailwindcss", -- ADD THIS
				"asm_ls",
				"bashls",
				"ccls",
				"clangd",
				"cmake",
				"csharpls",
				"cssls",
				"fish_lsp",
				"gdscript",
				"glsl_analyzer",
				"gradle_ls",
				"goovyls",
				"html",
				"jdtls",
				"jsonls",
				"lua_ls",
				"pylsp",
				"pyright",
			},
		})

		-- MODERN LSP SETUP - Replace the old vim.lsp.config approach
		local lspconfig = require("lspconfig")

		-- Default configuration for all servers
		local default_config = {
			capabilities = opts.capabilities,
			on_attach = opts.on_attach,
			on_init = opts.on_init,
		}

		local excluded = { "jdtls", "rust_analyzer" } -- Removed "ts_ls" since we're using "tsserver"

		local function setup_servers()
			for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
				if not vim.tbl_contains(excluded, server) then
					local server_config = vim.tbl_deep_extend("force", {}, default_config)

					-- Load server-specific settings if they exist
					local ok_settings, settings = pcall(require, "plugins.lsp.settings." .. server)
					if ok_settings then
						server_config = vim.tbl_deep_extend("force", server_config, settings)
					end

					-- Setup the server using modern lspconfig
					lspconfig[server].setup(server_config)
				end
			end

			-- Manual setup for gdscript if needed
			lspconfig.gdscript.setup(default_config)
		end

		setup_servers()

		-- Watch for new installs (updated for modern API)
		local mr = require("mason-registry")
		mr:on("package:install:success", function(pkg)
			if pkg.spec.categories[1] == "LSP" then
				vim.defer_fn(function()
					setup_servers()
					vim.notify("Auto-Enabled LSP: " .. pkg.name, vim.log.levels.INFO)
				end, 100)
			end
		end)
	end,
}

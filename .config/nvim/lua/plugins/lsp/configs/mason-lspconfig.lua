return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = { "mason-org/mason.nvim" },
	config = function()
		local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
		local ok_opts, opts = pcall(require, "plugins.lsp.opts")
		if not (ok_mason and ok_opts) then
			return
		end

		mason_lspconfig.setup()

		-- Default config
		vim.lsp.config("*", {
			capabilities = opts.capabilities,
			on_attach = opts.on_attach,
			on_init = opts.on_init,
		})

		local excluded = { "ts_ls", "jdtls", "rust_analyzer" }

		local function setup_servers()
			for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
				if not vim.tbl_contains(excluded, server) then
					local ok_settings, settings = pcall(require, "plugins.lsp.settings." .. server)
					if ok_settings then
						vim.lsp.config(server, settings)
					end
					vim.lsp.enable(server)
				end
			end
			vim.lsp.enable("gdscript")
		end

		setup_servers()

		-- Watch for new installs
		local mr = require("mason-registry")
		mr:on("package:install:success", function(pkg)
			if pkg.spec.categories[1] == "LSP" then
				vim.defer_fn(function()
					setup_servers()
					vim.notify("Auto-Enable: " .. pkg.name, vim.log.levels.INFO)
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end
		end)
	end,
}

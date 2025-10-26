return {
	"nvim-java/nvim-java",
	ft = { "java" },
	enabled = true,
	config = function()
		local wk = require("which-key")
		local java = require("java")
		java.setup({
			spring_boot_tools = { enabled = false },
		})

		local lspconfig = require("lspconfig")
		local opts = require("plugins.lsp.opts")

		-- Setup JDTLS LSP
		lspconfig.jdtls.setup({
			on_attach = opts.on_attach,
			capabilities = opts.capabilities,
			settings = {
				java = {
					configuration = {
						runtimes = {},
					},
				},
			},
		})

		local runner = java.runner.built_in
		local refactor = java.refactor
		local settings = java.settings

		wk.add({
			-- Runner
			{
				"<leader>Js",
				function()
					runner.run_app({})
				end,
				desc = "Start Main",
			},
			{
				"<leader>JS",
				function()
					runner.stop_app()
				end,
				desc = "Stop Main",
			},

			-- Refactor
			{
				"<leader>Jv",
				function()
					refactor.extract_variable()
				end,
				desc = "Extract Variable",
			},
			{
				"<leader>Jc",
				function()
					refactor.extract_constant()
				end,
				desc = "Extract Constant",
			},
			{
				"<leader>Jm",
				function()
					refactor.extract_method()
				end,
				desc = "Extract Method",
			},
			{
				"<leader>Jf",
				function()
					refactor.extract_field()
				end,
				desc = "Extract Field",
			},

			-- SDK / runtime
			{
				"<leader>Jr",
				function()
					settings.change_runtime()
				end,
				desc = "Change Project SDK",
			},
		})
	end,
}

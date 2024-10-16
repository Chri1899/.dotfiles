return {
		{
				"nvim-telescope/telescope.nvim",

				tag = "0.1.8",

				dependencies = {
						"nvim-lua/plenary.nvim"
				},

				config = function()
						local builtin = require("telescope.builtin")

						vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
						vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
						vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
				end
		},

		{
				"nivm-telescope/telescope-ui-select.nvim",
				config = function()
						require("telescope").setup({
								extensions = {
										["ui-select"] = {
												require("telescope.themes").get_dropdown {}
										}
								},
								pickers = {
										live_grep = {
												theme = "dropdown",
										},

										grep_string = {
												theme = "dropdown",
										},

										find_files = {
												theme = "dropdown",
										},

										lsp_references = {
												theme = "dropdown",
										},

										lsp_definitions = {
												theme = "dropdown",
										},

										lsp_declarations = {
												theme = "dropdown",
										},

										lsp_implementations = {
												theme = "dropdown",
										},
								}
						})

						-- load the ui-select extension
						require("telescope").load_extension("ui-select")
				end
		}
}

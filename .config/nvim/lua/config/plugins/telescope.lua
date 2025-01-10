return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",

		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-smart-history.nvim",
			"folke/todo-comments.nvim",
		},

		config = function()
			require("telescope").setup({
				pickers = {
					find_files = {
						theme = "dropdown",
					},
					colorscheme = {
						enable_preview = true,
					},
				},
				extensions = {
					wrap_results = true,

					fzf = {},
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "smart_history")
			pcall(require("telescope").load_extension, "ui_select")

			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>fh", builtin.help_tags)
			vim.keymap.set("n", "<leader>fd", builtin.find_files)
			vim.keymap.set("n", "<leader>fn", function()
				builtin.find_files({
					cwd = vim.fn.stdpath("config"),
				})
			end)

			vim.keymap.set("n", "<leader>fT", "<cmd>Telescope colorscheme<CR>")

			vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)

			vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find Todos" })

			require("config.telescope.multigrep").setup()
		end,
	},
}

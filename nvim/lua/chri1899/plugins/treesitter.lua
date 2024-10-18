return {
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
				"windwp/nvim-ts-autotag"
		},

		build = ':TSUpdate',
		config = function()
				local ts_config = require("nvim-treesitter.configs")

				ts_config.setup({
						-- make sure we have language servers installed
						ensure_installed = {
								"vim",
								"vimdoc",
								"lua",
								"java",
								"html",
								"css",
								"javascript",
								"json",
								"gitignore",
								"markdown",
								"tsx"
						},

						highlight = {enable = true},

						autotag = {enable = true}
				})
		end
}

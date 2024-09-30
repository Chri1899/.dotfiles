return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all"
				ensure_installed = { "vimdoc", "javascript", "c", "lua", "java", "python" },

				-- Install parsers synchronously (only applied to "ensure_installed")
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you dont have tree-sitter clie installed locally
				auto_install = true,

				indent = {
					enable = true
				},

				highlight = {
					-- false will disbale the whole extension
					enable = true,

					-- setting this to true will run :h syntax and tree-sitter at the same time
					-- set this to true if you depend on syntax being enabled
					-- using this option may slow down your editor, and you may see some duplcate
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = { "markdown" },
				},
			})
		end
	}
}

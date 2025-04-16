return {
  "MunifTanjim/prettier.nvim",

  config = function()
	local prettier = require("prettier")

	prettier.setup({
	  bin = "prettier",
	  filetypes = {
		"css",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"markdown",
		"typescript",
		"typescriptreact",
		"tsx",
		"yaml",
	  },
	})
  end
}

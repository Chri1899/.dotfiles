return {
	"nvim-flutter/flutter-tools.nvim",
	ft = { "dart" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim", -- optional for vim.ui.select
	},
	config = function()
		require("flutter-tools").setup({
			widget_guides = {
				enabled = true,
			},
			dev_log = {
				enabled = true,
				open_cmd = "tabedit",
			},
		})

		local wk = require("which-key")
		wk.add({
			{ "<leader>lf", require("telescope").extensions.flutter.commands, desc = "[FLUTTER] Open commands" },
		})
	end,
}

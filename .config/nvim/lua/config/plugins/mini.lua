return {
	"echasnovski/mini.nvim",
	version = false,

	config = function()
		local statusline = require("mini.statusline")
		local surround = require("mini.surround")

		-- Surround default keybinds
		-- Add surrounding "sa"
		-- delete surronding "sd"
		-- replace surrounding "sr"
		-- find surrounding "sf or sF"
		-- highlight surrounding "sh"

		statusline.setup({ use_icons = true })
		surround.setup()
	end,
}

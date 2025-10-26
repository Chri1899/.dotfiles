-- NOTE: Show diffs
return {
	"sindrets/diffview.nvim",
	event = {
		"BufReadPost",
		"BufNewFile",
	},
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
	},
	init = function()
		local wk = require("which-key")
		wk.add({
			{
				"<leader>gd",
				function()
					if next(require("diffview.lib").views) == nil then
						vim.cmd("DiffviewOpen")
					else
						vim.cmd("DiffviewClose")
					end
				end,
				desc = "Diffview",
			},
		})
	end,
}

-- NOTE: For managing error and warning messages
return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	init = function()
		require("which-key").add({
			{ "<leaderTb", "<cmd>Trouble diagnostics toggle fiter.buf=0<cr>", desc = "Buffer Diagnostics" },
			{ "<leader>Tw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace Diagnostics" },
		})
	end,
	opts = {
		focus = true, -- Focus the window when opened
	},
}

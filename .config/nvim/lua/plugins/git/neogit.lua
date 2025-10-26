-- NOTE: Interactive Git interface
return {
	"TimUntersberger/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim", -- integrates with Neogit for viewing diffs
		"lewis6991/gitsigns.nvim", -- for hunk staging inside Neogit
	},
	cmd = "Neogit",
	keys = {
		{ "<leader>gg", "<cmd>Neogit<CR>", desc = "Open Neogit" },
	},
	opts = {
		integrations = {
			diffview = true, -- lets Neogit use diffview.nvim for diffs
		},
		disable_commit_confirmation = true, -- optional: skip commit confirmation
	},
}

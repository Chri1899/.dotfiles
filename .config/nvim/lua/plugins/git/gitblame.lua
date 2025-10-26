-- NOTE: Git Blame
return {
	"f-person/git-blame.nvim",
	init = function()
		require("which-key").add({
			{ "<leader>gF", "<cmd>GitBlameOpenFileURL<cr>", desc = "Open File URL" },
			{ "<leader>gf", "<cmd>GitBlameCopyFileURL<cr>", desc = "Copy File URL" },
			{ "<leader>gs", "<cmd>GitBlameCopySHA<cr>", desc = "Copy SHA" },
			{ "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Blame" },
		})
	end,
	cmd = {
		"GitBlameToggle",
		"GitBlameEnable",
		"GitBlameOpenCommitURL",
		"GitBlameCopyCommitURL",
		"GitBlameOpenFileURL",
		"GitBlameCopyFileURL",
		"GitBlameCopySHA",
	},
	opts = {},
}

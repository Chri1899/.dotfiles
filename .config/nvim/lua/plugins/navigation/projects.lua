return {
	"coffebar/neovim-project",
	init = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>Pd", "<cmd>NeovimProjectDiscover<CR>", desc = "Discover" },
			{ "<leader>Ph", "<cmd>NeovimProjectHistory<CR>", desc = "History" },
			{ "<leader>Pr", "<cmd>NeovimProjectLoadRecent<CR>", desc = "Recent" },
			{ "<leader>Pl", "<cmd>NeovimProjectLoad<CR>", desc = "Load" },
		})
	end,
	opts = {
		projects = { -- define project roots
			"~/Documents/Projects/*",
			"~/.config/*",
		},
		picker = {
			type = "telescope", -- one of "telescope", "fzf-lua", or "snacks"
		},
	},
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		-- optional picker
		{ "nvim-telescope/telescope.nvim", tag = "0.1.4" },
		-- optional picker
		{ "ibhagwan/fzf-lua" },
		-- optional picker
		{ "folke/snacks.nvim" },
		{
			"Shatur/neovim-session-manager",
		},
	},
	lazy = false,
	priority = 100,
}

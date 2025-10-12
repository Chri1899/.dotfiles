return {
	"folke/which-key.nvim",
	dependencies = {
		{ "nvim-mini/mini.icons" },
	},
	event = "VimEnter",
	config = function()
		-- gain access to the which key plugin
		local wk = require("which-key")

		wk.add({
			-- SESSIONS
			{ "<leader>S", group = "/// SESSIONS ///" },
			{ "<leader>St", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle Autosave" },
			{ "<leader>SS", "<cmd>SessionSearch<CR>", desc = "Search" },
			{ "<leader>Sr", "<cmd>SessionRestore<CR>", desc = "Restore" },
			{ "<leader>Ss", "<cmd>SessionSave<CR>", desc = "Save" },
			{ "<leader>Sd", "<cmd>SessionDelete<CR>", desc = "Delete" },
			-- TOGGLE
			{ "<leader>t", group = "/// TOGGLES ///" },
			{ "<leader>tu", "<cmd>UndotreeToggle<CR>", desc = "Undotree" },
			-- FILE OPERATIONS
			{ "<leader>F", group = "/// FILES ///" },
			{
				"<leader>Ff",
				function()
					require("conform").format({ bufnr = 0 })
				end,
				desc = "Format",
			},
			-- FIND
			{ "<leader>f", group = "/// FIND ///" },
			-- SEARCH
			{ "<leader>s", group = "/// SEARCH ///" },
			-- TROUBLE
			{ "<leader>T", group = "/// TROUBLE ///" },
			-- LSP
			{ "<leader>l", group = "/// LSP ///" },
			-- PREVIEW
			{ "<leader>p", group = "/// PREVIEWS ///" },
			-- DEBUG
			{ "<leader>D", group = "/// DEBUG ///" },
			-- JDTLS
			{ "<leader>J", group = "/// JDTLS-JAVA ///" },
			-- CMAKE
			{ "<leader>C", group = "/// CMAKE ///" },
			-- PROJECTS
			{ "<leader>P", group = "/// PROJECTS ///" },
			-- WINDOW
			{ "<leader>W", group = "/// WINDOW ///" },
			{ "<leader>Wv", ":vsplit<cr>", desc = "Split Vertical" },
			{ "<leader>Wh", ":split<cr>", desc = "Split Horizontal" },
			-- GIT
			{ "<leader>g", group = "/// GIT ///" },
		})
	end,
}

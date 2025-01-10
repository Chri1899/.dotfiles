return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local todo_comments = require("todo-comments")

		-- set keymaps
		vim.keymap.set("n", "<leader>gn", function()
			todo_comments.jump_next()
		end, { desc = "[G]oto [N]ext Todo" })

		vim.keymap.set("n", "<leader>gp", function()
			todo_comments.jump_previous()
		end, { desc = "[G]oto [P]revious Todo" })

		todo_comments.setup()
	end,
}

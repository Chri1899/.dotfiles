return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPre", "BufNewFile" },

	config = function()
		local todo_comments = require("todo-comments")

		-- set keymaps
		vim.keymap.set("n", "<leader>nc", function()
			todo_comments.jump_next()
		end, { desc = "Next todo comment" })

		vim.keymap.set("n", "<leader>pc", function()
			todo_comments.jump_previous()
		end, { desc = "Previous todo comment" })

		todo_comments.setup()
	end,
}

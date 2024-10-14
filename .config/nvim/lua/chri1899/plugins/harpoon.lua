return {
		"ThePrimeagen/harpoon",

		config = function()
				local mark = require("harpoon.mark")
				local ui = require("harpoon.ui")

				require("harpoon").setup({})

				vim.keymap.set("n", "<leader>ha", mark.add_file)
				vim.keymap.set("n", "<leader>hl", ui.toggle_quick_menu)

				vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
				vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end)
				vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end)
				vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end)

				vim.keymap.set("n", "<leader><C-h>", function() ui.replace_at(1) end)
				vim.keymap.set("n", "<leader><C-j>", function() ui.replace_at(2) end)
				vim.keymap.set("n", "<leader><C-k>", function() ui.replace_at(3) end)
				vim.keymap.set("n", "<leader><C-l>", function() ui.replace_at(4) end)
 	end
}

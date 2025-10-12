return {
	"rmagatti/goto-preview",
	depependencies = { "rmagatti/logger.nvim" },
	event = "LspAttach",
	init = function()
		local wk = require("which-key")
		local gtp = require("goto-preview")

		wk.add({
			{
				"<leader>pq",
				function()
					gtp.dismiss_preview(0)
				end,
				desc = "Quit",
			},
			{ "<leader>pd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Defintion" },
			{
				"<leader>pt",
				"<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
				desc = "Type Definition",
			},
			{
				"<leader>pi",
				"<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
				desc = "Implementation",
			},
			{ "<leader>pD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", desc = "Declaration" },
			{ "<leader>pQ", "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "Close All" },
		})
	end,
	config = true,
}

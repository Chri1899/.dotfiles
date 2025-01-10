return {
  "folke/which-key.nvim",
  event = "VimEnter",
  opts = {
	delay = 0,
	icons = {
	  mappings = vim.g.have_nerd_font,
	},
	-- Existing key chains
	spec = {
	  {"<leader>f", group = "[F]ind" },
	  {"<leader>u", group = "[U]ndo" },
	  {"<leader>g", group = "[G]oto" },
	  {"<leader>-", group = "Oil Explorer" },
	  {"<leader>b", group = "[B]uffer" },
	  {"<leader>t", group = "[T]oggle" },
	}
  }
}

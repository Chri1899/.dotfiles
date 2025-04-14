return {
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
		transparent = true,
	  })
    end
  },

  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load colorscheme
      -- directly inside the plugin declaration
      vim.g.gruvbox_material_enable_italic = true
	  vim.g.gruvbox_material_transparent_background = 1
      vim.cmd.colorscheme("gruvbox-material")
    end
  },

  {
	"craftzdog/solarized-osaka.nvim",
	lazy = true,
	priority = 1000,
	config = function()
	  transparent = true
	end
  }
}

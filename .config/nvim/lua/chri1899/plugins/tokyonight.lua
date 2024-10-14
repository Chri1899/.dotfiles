return {
	"folke/tokyonight.nvim",
	config = function()
		require("tokyonight").setup({
			-- Here comes the config
			transparent = true,
			style = "storm",
			styles = {
				comments = { italic = false },
				keywords = { italic = false },

				sidebars = "dark",
				floats = "dark",
			},
		})
	end
}

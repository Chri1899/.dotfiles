return {
		"nvim-java/nvim-java",

		dependencies = {
				{
						"neovim/nvim-lspconfig",
						opts = {
								servers = {
										jdtls = {
										},
								},
								setup = {
										jdtls = function()
												require("java").setup({
												})
										end,
								},
						},
				},
		},
}

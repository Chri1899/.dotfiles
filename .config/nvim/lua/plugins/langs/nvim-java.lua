-- NOTE: For Java
return {
	"nvim-java/nvim-java",
	ft = { "java" },
	config = function()
		require("java").setup({
			spring_boot_tools = { false },
		})
		require("lspconfig").jdtls.setup({
			on_attach = require("plugins.lsp.opts").on_attach,
			capabilities = require("plugins.lsp.opts").capabilities,
		})
	end,
}

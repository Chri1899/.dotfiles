return {
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"mdx",
	},
	root_dir = require("lspconfig.util").root_pattern(
		"tailwind.config.js",
		"tailwind.config.ts",
		"tailwind.config.cjs",
		"package.json"
	),
	init_options = {
		userLanguages = {
			html = "html",
			css = "css",
			scss = "css",
			javascript = "javascript",
			javascriptreact = "javascriptreact",
			typescript = "typescript",
			typescriptreact = "typescriptreact",
		},
	},
}

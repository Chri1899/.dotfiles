return {
	filetypes = {
		"glsl",
		"vert",
		"frag",
		"geom",
		"comp",
	},
	root_dir = require("lspconfig").util.root_pattern(".git", "."),
}

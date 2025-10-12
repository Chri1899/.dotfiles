return {
	"hrsh7th/nvim-cmp",
	enabled = false,
	event = { "InsertEnter", "CmdlineEnter" },
	opts = function(_, opts)
		require("cmp").setup.filetype({ "mysql", "sql" }, {
			sources = {
				{ name = "vim-dadbod-completion" },
				{ name = "buffer" },
			},
		})

		require("luasnip").filetype_extend("javascriptreact", { "html" })
		require("luasnip").filetype_extend("typescriptreact", { "html" })
		require("luasnip").filetype_extend("svelte", { "html" })
		require("luasnip").filetype_extend("vue", { "html" })
		require("luasnip").filetype_extend("php", { "html" })
		require("luasnip").filetype_extend("javascript", { "javascriptreact" })
		require("luasnip").filetype_extend("typescript", { "typescriptreact" })
		--NOTE: add border for cmp window
		if vim.g.border_enabled then
			opts.window = {
				completion = require("cmp").config.window.bordered(),
				documentation = require("cmp").config.window.bordered(),
			}
		end
	end,
	dependencies = {
		-- Commandline completions
		{
			"hrsh7th/cmp-cmdline",
			config = function()
				local cmdline_mappings = vim.tbl_extend("force", {}, require("cmp").mapping.preset.cmdline(), {
					-- ["<CR>"] = { c = require("cmp").mapping.confirm { select = true } },
				})

				require("cmp").setup.cmdline(":", {
					mapping = cmdline_mappings,
					sources = {
						{ name = "cmdline" },
					},
				})
			end,
		},
		{
			"L3MON4D3/LuaSnip",
			dependencies = "rafamadriz/friendly-snippets",
			build = "make install_jsregexp",
		},
	},
}

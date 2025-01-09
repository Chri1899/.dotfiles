return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See config section
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		{ "j-hui/fidget.nvim", opts = {} },

		-- Autoformatting
		"stevearc/conform.nvim",
	},

	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = servers,
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local lspconfig = require("lspconfig")

		local servers = {
			bashls = true,
			lua_ls = {
				server_capabilities = {
					semanticTokensProvider = vim.NIL,
				},
			},
			pyright = true,
			clangd = {
				init_options = { clangdFileStatus = true },
				filetypes = { "c", "cpp" },
			},
			cmake = true,
			jsonls = {
				server_capabilities = {
					documentFormattingProvider = false,
				},
				settings = {
					json = {
						validate = { enable = true },
					},
				},
			},
		}

		local servers_to_install = vim.tbl_filter(function(key)
			local t = servers[key]
			if type(t) == "table" then
				return not t.manual_install
			else
				return t
			end
		end, vim.tbl_keys(servers))

		require("mason").setup()
		local ensure_installed = {
			"clangd",
			"cmake",
			"lua_ls",
			"pyright",
			"stylua",
		}

		vim.list_extend(ensure_installed, servers_to_install)
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		for name, config in ipairs(servers) do
			if config == true then
				config = {}
			end
			config = vim.tbl_deep_extend("force", {}, {
				capabilities = capabilities,
			}, config)

			lspconfig[name].setup(config)
		end

		local disbale_semantic_tokens = {
			lua = true,
		}

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

				local settings = servers[client.name]
				if type(settings) ~= "table" then
					settings = {}
				end

				local builtin = require("telescope.builtin")

				vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
				vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
				vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
				vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

				vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = 0 })
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
				vim.keymap.set("n", "<leader>wd", builtin.lsp_document_symbols, { buffer = 0 })

				local filetype = vim.bo[bufnr].filetype
				if disbale_semantic_tokens[filetype] then
					client.server_capabilities.semanticTokensProvider = nil
				end

				-- Override server capabailities
				if settings.server_capabilities then
					for k, v in pairs(settings.server_capabilities) do
						if v == vim.NIL then
							---@diagnostic disable-next-line: cast-local-type
							v = nil
						end

						client.server_capabilities[k] = v
					end
				end
			end,
		})

		require("config.autoformat").setup()
	end,
}

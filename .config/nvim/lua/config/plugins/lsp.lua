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
	  local builtin = require("telescope.builtin")
	  -- This configures the current buffer an existing LSP attaches to
	  -- on file open
	  vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
		callback = function(bufnr)
		  local opts = { noremap = true }
		  -- LSP Specific keymaps
		  vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, opts)
		  vim.keymap.set("n", "<leader>gr", builtin.lsp_references, opts)
		  vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
		  vim.keymap.set("n", "<leader>gT", vim.lsp.buf.type_definition, opts)
		  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

		  -- Code Action
		  vim.keymap.set("n", "<leader>br", vim.lsp.buf.rename, opts)
		  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		  vim.keymap.set("n", "<leader>gs", builtin.lsp_document_symbols, opts)
		end
	  })

	  -- LSP Configuration
	  local capabilities = require("blink.cmp").get_lsp_capabilities()

	  -- Enable the following language servers
	  local servers = {
		clangd = {},
		cmake = {},
		pyright = {},
		lua_ls = {
		  settings = {
			Lua = {
			  completion = {
				callSnippet = "Replace",
			  },
			},
		  },
		},
	  }

	  -- Ensure the defined tools are installed
	  local ensure_installed = vim.tbl_keys(servers or {})
	  vim.list_extend(ensure_installed, {
		"stylua", -- Used to format Lua code
	  })
	  require("mason-tool-installer").setup { ensure_installed = ensure_installed }

	  require("mason-lspconfig").setup {
		handlers = {
		  function(server_name)
			local server = servers[server_name] or {}
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			require("lspconfig")[server_name].setup(server)
		  end,
		},
	  }
	end
}

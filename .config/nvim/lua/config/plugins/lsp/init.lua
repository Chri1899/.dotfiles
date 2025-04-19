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
		"mfussenegger/nvim-jdtls",

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
		callback = function()
		  require("which-key").add(
			{"<leader>c", group = "[C]ode" }
		  )
		  
		  -- LSP Specific keymaps
		  vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinitions" })
		  vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" })
		  vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclarations" })
		  vim.keymap.set("n", "<leader>gT", vim.lsp.buf.type_definition, { desc = "[G]oto [T]ype Definition" })
		  vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

		  -- Code Action
		  vim.keymap.set("n", "<leader>br", vim.lsp.buf.rename, { desc = "[B]uffer [R]ename" })
		  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
		  vim.keymap.set("n", "<leader>gs", builtin.lsp_document_symbols, { desc = "[G]oto Document [S]ymbols" })
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
		html = {},
		jsonls = {},
		cssls = {},
		tailwindcss = {},
		eslint = {},
		prettier = {},
	  }

	  -- Ensure the defined tools are installed
	  local ensure_installed = vim.tbl_keys(servers or {})
	  vim.list_extend(ensure_installed, {
		"stylua", -- Used to format Lua code
		"jdtls",
		"java-debug-adapter",
		"java-test"
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

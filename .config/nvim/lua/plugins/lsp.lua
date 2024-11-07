local servers = {
    "jdtls",
    "lua_ls",
    "html",
    "cssls",
    "pyright",
    "jsonls",
    "bashls",
    "clangd",
}

local tools = {
    "clang-format",
}

return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = servers,
            })
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {"java-debug-adapter", "java-test" }
            })
        end
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup({
                    ensure_installed = tools,
            })
        end
    },
    {
        "mfussenegger/nvim-jdtls",
        dependencies = {
            "mfussenegger/nvim-dap"
        }
    },
    {
        "neovim/nvim-lspconfig",

        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
        },

        config = function()
            local lspconfig = require("lspconfig")
            local cmp = require("cmp")
            local cmp_lsp = require("cmp_nvim_lsp")

            local capabilities = cmp_lsp.default_capabilities()

            local on_attach = function(client, bufnr)
                -- Mappings
                local bufopts = { noremap=true, silent=true, buffer=bufnr }
                vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, { desc = "LSP: Goto Declaration"}))
                vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, { desc = "LSP: Goto Definition"}))
                vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, vim.tbl_extend("force", bufopts, { desc = "LSP: Goto Implementation"}))
                vim.keymap.set("n", "<leader>lc", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "LSP: Code Action"}))
                vim.keymap.set("n", "<leader>lH", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "LSP: Hover"}))
                vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "LSP: Rename"}))
                vim.keymap.set("n", "<leader>lR", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, { desc = "LSP: References"}))
                vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, vim.tbl_extend("force", bufopts, { desc = "LSP: Type Definition"}))
            end

            -- Setup for all the Servers
            lspconfig.html.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.cssls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.pyright.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.jsonls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.bashls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.clangd.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                filetypes = { "h", "c", "cpp", "cc", "objc", "objcpp" },
                cmd = {
                    "clangd",
                    "--background-index",
                },
                single_file_support = true,
                root_dir = lspconfig.util.root_pattern(
                    ".clangd",
                    ".clang-tidy",
                    ".clang-format",
                    "compile_commands.json",
                    "compile_flags.txt",
                    "configure.ac",
                    ".git"
                )
            })
            lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                        }
                    }
                }
            })

            -- Setup CMP
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                }, {
                    { name = 'buffer' },
                })
            })

            vim.diagnostic.config({
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                }
            })
        end
    }
}


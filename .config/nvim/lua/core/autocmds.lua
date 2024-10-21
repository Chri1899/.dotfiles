vim.cmd [[
    augroup jdtls_lsp
        autocmd!
        autocmd FileType java lua require'lsp.jdtls'.setup_jdtls()
    augroup end
]]

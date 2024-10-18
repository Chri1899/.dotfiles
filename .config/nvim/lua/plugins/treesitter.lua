return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    config = function()
        require("nvim-treesitter.configs").setup({
            -- Ensure that those parsers are installed
            ensure_installed = {
                "vimdoc", 
                "javascript", 
                "c", 
                "cpp", 
                "lua", 
                "bash", 
                "java",
                "json",
                "vim",
                "html",
                "css",
            },

            -- Install parsers synchronously
            sync_install = false,

            -- Auto install parsers
            auto_install = true,

            indent = {
                enable = true,
            },

            highlight = {
                enable = true,
            },
        })
    end
}

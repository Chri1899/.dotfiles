return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  config = function()
    require "nvim-treesitter.configs".setup {
      -- List of parser names or "all"
      ensure_installed = { "bash", "c", "cpp", "lua", "vim", "vimdoc" },

      -- Install parsers synchronously
      sync_install = false,

      -- Auto install missing parsers when entering a buffer
      auto_install = false,

      -- List of parsers to ignore
      ignore_install = {},

      highlight = {
        enable = true,

        disbale = {},

        additional_vim_regex_highlighting = false,
      }
    }
  end
}

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  config = function()
    require "nvim-treesitter.configs".setup {
      -- List of parser names or "all"
      ensure_installed = { "bash", "c", "cpp", "lua", "vim", "vimdoc", "java", "html", "javascript", "typescript", "markdown", "css", "json", "tsx" },

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
      },

	  autotag = {
		enable = true,
	  },
    }

	local parser_config = require"nvim-treesitter.parsers".get_parser_configs()
	parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
  end
}

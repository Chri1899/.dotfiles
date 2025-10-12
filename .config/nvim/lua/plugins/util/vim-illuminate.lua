return {
  "RRethy/vim-illuminate",
  -- enabled = false,
  event = "BufEnter",
  opts = {
    filetypes_denylist = { "NvimTree", "TelescopePrompt", "NeogitStatus", "lazy", "mason" },
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}

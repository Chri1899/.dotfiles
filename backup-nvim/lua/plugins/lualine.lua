return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },

    config = function() 
       require('lualine').setup ({
           options = {
               icons_enabled = true,
               theme = "nord",
               -- Some useful glyphs
               -- -- https://www.nerdfonts.com/cheat-sheet
               -- --        
               section_separators = { left = '', right = '' },
               component_separators = { left = '', right = '' },
               disabled_filetypes = { 'alpha', 'neo-tree', 'Avante' },
               always_divide_middle = true,
           },
           sections = {
               lualine_a = { mode },
               lualine_b = { 'branch' },
               lualine_c = { filename },
               lualine_x = { diagnostics, diff, { 'encoding', cond = hide_in_width }, { 'filetype', cond = hide_in_width } },
               lualine_y = { 'location' },
               lualine_z = { 'progress' },
           },
           inactive_sections = {
               lualine_a = {},
               lualine_b = {},
               lualine_c = { { 'filename', path = 1 } },
               lualine_x = { { 'location', padding = 0 } },
               lualine_y = {},
               lualine_z = {},
           },
           tabline = {},
--           extensions = { 'fugitive' },
       })
   end
}

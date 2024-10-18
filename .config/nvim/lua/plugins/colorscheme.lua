return {
    "shaunsingh/nord.nvim",
    lazy = false,

    config = function()
        vim.g.nord_contrast = true              -- Different Background on popups and sidebars
        vim.g.nord_borders = false              -- Disable Border between splits
        vim.g.nord_disable_background = true    -- Show the Terminal background
        vim.g.nord_italic = false               -- Disable italics
        vim.g.nord_bold = false                 -- Disable bolds

        require("nord").set()

        local bg_transparent = true
    end
}

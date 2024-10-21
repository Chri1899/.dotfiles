return {
    "folke/which-key.nvim",

    config = function()
        local wk = require("which-key")

        wk.add({
            { "<leader>s", group = "Search" },
            { "<leader>w", group = "Window" },
            { "<leader>h", group = "Harpoon" },
            { "<leader>f", group = "Find" },
            { "<leader>d", group = "Debug" },
            { "<leader>t", group = "Trouble" },
            { "<leader>S", group = "Save" },
            { "<leader>g", group = "Git" }
        })
    end
}

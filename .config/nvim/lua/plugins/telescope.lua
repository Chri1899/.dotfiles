return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.8",

    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    config = function()
        local telescope = require "telescope"
        local builtin = require "telescope.builtin"
        local actions = require "telescope.actions"

        require("telescope").setup {
            defaults = {
                n = {
                    ["q"] = actions.close,
                },
            },
            pickers = {
                find_files = {
                    file_ignore_patterns = { ".git", ".venv" },
                    hidden = true,
                },
                live_grep = {
                    file_ignore_patterns = { ".git", ".venv" },
                    additional_args = function(_)
                        return { "--hidden" }
                    end,
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown(),
                },
            },
        }

        pcall(require("telescope").load_extension, "ui-select")

        
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind files" })
        vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "[F]ind [G]it Files" })
        vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
        vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    end
}

-- Set Leader Key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disbale spacebars default behaviour in normal and visual mode
vim.keymap.set({"n", "v"}, "<Space>", "<Nop>")

-- Save File
vim.keymap.set("n", "<Leader>Ss", "<cmd> w <CR>", { desc = "Save File (with auto format)" })

-- Save File without auto-formatting
vim.keymap.set("n", "<Leader>Sn", "<cmd>noautocmd w <CR>", { desc = "Save File without auto format." })

-- Vertical Scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Find and center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Window Management
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Window: Split vertical" })
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Window: Split horizontal" })
vim.keymap.set("n", "<leader>wc", ":close<CR>", { desc = "Window: Close split "})

-- Press JJ to exit insert mode
vim.keymap.set("i", "jj", "<ESC>")

-- Indent Improvement
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Source Config
vim.keymap.set("n", "<leader><leader>", ":so<CR>", { desc = "Source Config" })

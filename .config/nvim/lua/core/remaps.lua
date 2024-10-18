-- Set Leader Key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disbale spacebars default behaviour in normal and visual mode
vim.keymap.set({"n", "v"}, "<Space>", "<Nop>")

-- Save File
vim.keymap.set("n", "<Leader>s", "<cmd> w <CR>")

-- Save File without auto-formatting
vim.keymap.set("n", "<Leader>sn", "<cmd>noautocmd w <CR>")

-- Delete single char without copying into registert
vim.keymap.set("n", "x", "_x")

-- Vertical Scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Find and center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Window Management
vim.keymap.set("n", "<leader>wv", "<C-w>v")
vim.keymap.set("n", "<leader>wh", "<C-w>h")
vim.keymap.set("n", "<leader>wc", ":close<CR>")

-- Press JJ to exit insert mode
vim.keymap.set("i", "jj", "<ESC>")

-- Indent Improvement
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Source Config
vim.keymap.set("n", "<leader><leader>", ":so<CR>")

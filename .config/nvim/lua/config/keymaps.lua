-- Set Leader Keybinding to space
vim.g.mapleader = " "
vim.g.globalmapleader = " "

local set = vim.keymap.set

-- remove search highlights after searching
set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

-- Exit Vims terminal mode
set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Disable Arrow Keys
set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Better window navigation WK [W]
set("n", "<C-h>", ":wincmd h<cr>", { desc = "Move focus to the left window" })
set("n", "<C-l>", ":wincmd l<cr>", { desc = "Move focus to the right window" })
set("n", "<C-j>", ":wincmd j<cr>", { desc = "Move focus to the lower window" })
set("n", "<C-k>", ":wincmd k<cr>", { desc = "Move focus to the upper window" })

-- Stay in indent mode
set("v", "<", "<gv", { desc = "Indent left in visual mode" })
set("v", ">", ">gv", { desc = "Indent right in visual mode" })

-- Move Line up or down in Visual Mode
set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")

-- Remove line break
set("n", "J", "mzJ`z")

-- Center on page scroll
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")

-- Center on search navigation
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

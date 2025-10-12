vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

local opt = vim.opt
-- Left Column
opt.number = true -- Display line numbers
opt.relativenumber = true -- Relative numbers
opt.numberwidth = 2 -- width of line number column
opt.signcolumn = "yes" -- always show sign column
opt.wrap = false -- display lines as single lines
opt.scrolloff = 10 -- number of lines to keep above/beyond cursor
opt.sidescrolloff = 8 -- number of lines to keep left/right of cursor

-- Tab/Spacing behavior
opt.expandtab = true -- Convert tabs to spaces
opt.shiftwidth = 4 -- number of spaces for each indent
opt.tabstop = 4 -- numbers of spaces for a tab char
opt.softtabstop = 4 -- number of spaces for tab key
opt.smartindent = true -- enable smart indentation
opt.breakindent = true -- enable line breaking indentation

-- General Behaviours
opt.backup = false -- disable backup files
opt.clipboard = "unnamedplus" -- system clipboard access
opt.fileencoding = "UTF-8" -- set file encoding
opt.mouse = "a" -- mouse support
opt.showmode = false -- hide mode display
opt.splitbelow = true -- force splits belove
opt.splitright = true -- force splits to the right
-- opt.termguicolors = true -- enable term GUI colors
opt.undofile = true -- enable persistens undo
opt.updatetime = 100 -- faster completion
opt.writebackup = false -- prevent editing of files beeing edited elsewhere
opt.cursorline = true -- highlight currentline
opt.swapfile = false -- creates a swapfile

-- searching behavior
opt.hlsearch = true -- hightight all matches in search
opt.ignorecase = true -- ignore case in search
opt.smartcase = true -- match case if explicitly stated

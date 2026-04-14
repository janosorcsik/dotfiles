-- Appearance
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true

-- Editing
vim.opt.smartindent = true
vim.opt.confirm = true
vim.opt.scrolloff = 8

-- System
vim.opt.swapfile = false
vim.opt.undofile = true

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

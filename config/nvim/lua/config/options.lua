-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Editor
vim.opt.showmode = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.smartindent = true
vim.opt.confirm = true

-- System
vim.opt.swapfile = false
vim.opt.undofile = true

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

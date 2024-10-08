vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.scrolloff = 8

vim.opt.clipboard = "unnamedplus"
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Install Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"catppuccin/nvim",
		name = "catppuccin",
		build = ":CatppuccinCompile",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "UIEnter",
		config = function()
			require("plugins.lualine")
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		event = "VeryLazy",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("plugins.telescope")
		end,
	},
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		config = function()
			require("mini.comment").setup({
				hooks = {
					pre = function()
						require("ts_context_commentstring.internal").update_commentstring()
					end,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUninstall", "TSInstall" },
		dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("plugins.treesitter")
		end,
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- LSP Support
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"Hoffs/omnisharp-extended-lsp.nvim", -- go to definition in nugets/system dlls
			-- Autocompletion
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			-- Snippets
			"L3MON4D3/LuaSnip",
		},
		config = function()
			require("plugins.lsp")
		end,
	},
}, {
	defaults = { lazy = true },
	install = {
		colorscheme = { "catppuccin" },
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"man",
				"gzip",
				"matchit",
				"matchparen",
				"rplugin",
				"spellfile",
				"shada",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

require("set")
require("netrw")
require("maps")
require("autocmds")

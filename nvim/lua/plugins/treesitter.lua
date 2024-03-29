require("nvim-treesitter.configs").setup({
	sync_install = false,
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	indent = { enable = true },
	enable_autocmd = false,
	ensure_installed = {
		"bash",
		"c_sharp",
		"javascript",
		"jsonc",
		"lua",
		"markdown",
		"typescript",
		"vim",
		"vimdoc",
		"yaml",
	},
})

local register = vim.treesitter.language.register
register("json", "jsonc")
register("zsh", "bash")

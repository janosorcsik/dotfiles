require("nvim-treesitter.configs").setup({
	sync_install = false,
	highlight = { enable = true, additional_vim_regex_highlighting = false },
	indent = { enable = true },
	context_commentstring = { enable = true, enable_autocmd = false },
	ensure_installed = {
		"bash",
		"c_sharp",
		"help",
		"javascript",
		"jsonc",
		"lua",
		"markdown",
		"typescript",
		"vim",
		"yaml",
	},
})

require("nvim-treesitter.parsers").filetype_to_parsername.json = "jsonc"
require("nvim-treesitter.parsers").filetype_to_parsername.zsh = "bash"

require("mini.comment").setup({
	hooks = {
		pre = function()
			require("ts_context_commentstring.internal").update_commentstring()
		end,
	},
})

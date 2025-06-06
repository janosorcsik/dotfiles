return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "VeryLazy",
	cmd = {
		"TSUpdateSync",
		"TSUpdate",
		"TSInstall",
	},
	opts = {
		auto_install = true,
		ensure_installed = {
			"bash",
			"c_sharp",
			"diff",
			"html",
			"javascript",
			"json",
			"jsonc",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		},
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	},
}

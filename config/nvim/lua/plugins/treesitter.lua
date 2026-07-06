return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		require("nvim-treesitter").install({
			"bash",
			"c_sharp",
			"diff",
			"go",
			"html",
			"javascript",
			"json",
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
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}

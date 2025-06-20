return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			transparent_background = true,
			integrations = {
				blink_cmp = true,
				mason = true,
				snacks = true,
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}

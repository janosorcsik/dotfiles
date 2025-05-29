return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			integrations = {
				blink_cmp = true,
				mason = true,
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}

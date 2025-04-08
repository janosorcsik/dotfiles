require("telescope").setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		preview = {
			hide_on_startup = false,
		},
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				preview_width = 0.6,
			},
			preview_cutoff = 120,
		},
		dynamic_preview_title = true,
	},
	pickers = {
		live_grep = {
			previewer = true,
		},
	},
})

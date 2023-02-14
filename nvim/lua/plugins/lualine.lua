require("lualine").setup({
	options = {
		component_separators = "|",
		section_separators = "",
		globalstatus = true,
		disabled_filetypes = {
			"alpha",
			"mason",
			"lazy",
			"TelescopePrompt",
		},
	},
})

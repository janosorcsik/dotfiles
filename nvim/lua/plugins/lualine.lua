require("lualine").setup({
	options = {
		component_separators = "|",
		section_separators = "",
		globalstatus = true,
		disabled_filetypes = {
			"mason",
			"lazy",
			"TelescopePrompt",
		},
	},
})

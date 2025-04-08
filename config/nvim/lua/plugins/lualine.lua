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
		theme = "catppuccin",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { "filename" },
		lualine_x = {
			{
				"filetype",
				colored = true,
				icon_only = true,
			},
			"encoding",
			"fileformat",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

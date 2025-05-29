return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			theme = "catppuccin",
			component_separators = "|",
			section_separators = "",
			globalstatus = true,
		},
		sections = {
			lualine_a = {
				"mode",
			},
			lualine_b = {
				"branch",
				"diff",
				"diagnostics",
			},
			lualine_c = {
				{
					"filename",
					path = 1,
				},
			},
			lualine_x = {
				{
					"filetype",
					colored = true,
					icon_only = true,
				},
				"encoding",
				"fileformat",
			},
			lualine_y = {
				"progress",
			},
			lualine_z = {
				"location",
			},
		},
		extensions = {
			"lazy",
			"mason",
		},
	},
}

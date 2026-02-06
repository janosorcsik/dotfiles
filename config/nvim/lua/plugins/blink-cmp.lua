return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = "rafamadriz/friendly-snippets",
	event = "InsertEnter",
	opts = {
		keymap = {
			preset = "enter",
		},
		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},

		},
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
			},
		},
		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
	},
	opts_extend = {
		"sources.default",
	},
}

return {
	{
		"mason-org/mason.nvim",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
			ui = {
				border = "rounded",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = "neovim/nvim-lspconfig",
		opts = {
			ensure_installed = {
				"bashls",
				"eslint",
				"jsonls",
				"lua_ls",
				"tailwindcss",
				"ts_ls",
				"yamlls",
				"vimls",
			},
		},
	},
}

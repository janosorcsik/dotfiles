return {
	{
		"mason-org/mason.nvim",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "neovim/nvim-lspconfig", "saghen/blink.cmp" },
		config = function()
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})
			require("mason-lspconfig").setup({
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
			})
		end,
	},
}

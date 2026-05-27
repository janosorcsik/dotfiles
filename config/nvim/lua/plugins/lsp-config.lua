return {
	{
		"mason-org/mason.nvim",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
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
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.lsp.config("roslyn_ls", {
				filetypes = { "razor", "cs" },
				settings = {
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "openFiles",
						dotnet_compiler_diagnostics_scope = "openFiles",
					},
				},
			})
			vim.lsp.enable("roslyn_ls")
		end,
	},
}

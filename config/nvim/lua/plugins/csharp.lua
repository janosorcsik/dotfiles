return {
	"iabdelkareem/csharp.nvim",
	dependencies = {
		"mfussenegger/nvim-dap",
		"Tastyep/structlog.nvim",
	},
	opts = {
		lsp = {
			omnisharp = {
				enable = false,
			},
			roslyn = {
				enable = true,
				cmd_path = vim.fn.stdpath("data")
					.. "/mason/packages/roslyn/libexec/Microsoft.CodeAnalysis.LanguageServer.dll",
			},
		},
	},
}

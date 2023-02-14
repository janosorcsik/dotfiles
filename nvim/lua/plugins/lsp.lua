local lsp = require("lsp-zero")

lsp.preset("recommended")

-- ensure that these LSP servers are installed
lsp.ensure_installed({
	"bashls",
	"eslint",
	"jsonls",
	"lua_ls",
	"omnisharp",
	"tsserver",
	"yamlls",
	"vimls",
})

-- Make the Lua LSP server aware of the vim runtime paths
lsp.nvim_workspace()

lsp.set_preferences({
	sign_icons = {
		error = "E",
		warn = "W",
		hint = "H",
		info = "I",
	},
})

-- Fix Undefined global 'vim'
lsp.configure("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

lsp.configure("omnisharp", {
	handlers = {
		["textDocument/definition"] = require("omnisharp_extended").handler,
	},
})

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
})

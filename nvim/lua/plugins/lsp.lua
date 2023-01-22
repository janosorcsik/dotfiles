local lsp = require("lsp-zero")

lsp.preset("recommended")

-- ensure that these LSP servers are installed
lsp.ensure_installed({
	"bashls",
	"eslint",
	"jsonls",
	"csharp_ls",
	"sumneko_lua",
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

-- Completion
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	["<C-Space>"] = cmp.mapping.complete(),
	-- disable tab completion
	["<Tab>"] = cmp.config.disable,
	["<S-Tab>"] = cmp.config.disable,
})

lsp.setup_nvim_cmp({
	mapping = cmp_mappings,
	sources = {
		{ name = "nvim_lsp_signature_help" },
		{ name = "path" },
		{ name = "luasnip", max_item_count = 4 },
		{ name = "nvim_lsp", priority = 10 },
		{ name = "buffer" },
	},
})

-- Fix Undefined global 'vim'
lsp.configure("sumneko_lua", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

lsp.configure("csharp_ls", {
	handlers = {
		["textDocument/definition"] = require("csharpls_extended").handler,
	},
})

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
})

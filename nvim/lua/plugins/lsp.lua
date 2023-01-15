local lsp = require("lsp-zero")

lsp.preset("recommended")

-- ensure that these LSP servers are installed
lsp.ensure_installed({
	"bashls",
	"eslint",
	"jsonls",
	"omnisharp",
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
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_document_symbol" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
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

local omnisharp_extended = require("omnisharp_extended")

lsp.configure("omnisharp", {
	enable_roslyn_analyzers = true,
	organize_imports_on_format = true,
	enable_import_completion = true,
	handlers = {
		["textDocument/definition"] = omnisharp_extended.handler,
	},
})

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
})

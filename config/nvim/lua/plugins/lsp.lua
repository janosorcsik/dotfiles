local cmp = require("cmp")
local lspconfig = require("lspconfig")
local lspzero = require("lsp-zero")

lspzero.on_attach(function(_, bufnr)
	local opts = {
		buffer = bufnr,
		silent = true,
	}

	vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
end)

require("mason").setup({
	auto_install = true,
})
require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"eslint",
		"jsonls",
		"lua_ls",
		"omnisharp",
		"tailwindcss",
		"ts_ls",
		"yamlls",
		"vimls",
	},
	handlers = {
		lspzero.default_setup,
		lua_ls = function()
			lspconfig.lua_ls.setup(lspzero.nvim_lua_ls())
		end,
		omnisharp = function()
			lspconfig.omnisharp.setup({
				handlers = {
					["textDocument/definition"] = require("omnisharp_extended").handler,
					["textDocument/typeDefinition"] = require("omnisharp_extended").handler,
				},
			})
		end,
	},
})

cmp.setup({
	mapping = {
		["<cr>"] = cmp.mapping.confirm({
			select = true,
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "vsnip" },
	},
})

vim.diagnostic.config({
	virtual_text = true,
	float = {
		source = "always",
	},
})

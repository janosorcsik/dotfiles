vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"help",
		"man",
		"qf",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, {
					force = true,
				})
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

-- LSP keymaps on attach
-- Neovim 0.11+ built-ins (no setup needed):
-- |grn| in Normal mode maps to |vim.lsp.buf.rename()|
-- |grr| in Normal mode maps to |vim.lsp.buf.references()|
-- |gri| in Normal mode maps to |vim.lsp.buf.implementation()|
-- |grt| in Normal mode maps to |vim.lsp.buf.type_definition()|
-- |gO|  in Normal mode maps to |vim.lsp.buf.document_symbol()|
-- |gra| in Normal and Visual mode maps to |vim.lsp.buf.code_action()|
-- |CTRL-S| in Insert and Select mode maps to |vim.lsp.buf.signature_help()|
-- |K|   in Normal mode maps to |vim.lsp.buf.hover()|
--
-- gd is NOT a built-in LSP keymap (Vim's built-in gd only highlights local decl):
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
	end,
})

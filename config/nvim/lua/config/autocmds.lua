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

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		-- |grn| in Normal mode maps to |vim.lsp.buf.rename()|
		-- |grr| in Normal mode maps to |vim.lsp.buf.references()|
		-- |gri| in Normal mode maps to |vim.lsp.buf.implementation()|
		-- |gO| in Normal mode maps to |vim.lsp.buf.document_symbol()|
		-- |gra| in Normal and Visual mode maps to |vim.lsp.buf.code_action()|
		-- |CTRL-S| in Insert and Select mode maps to |vim.lsp.buf.signature_help()|
		vim.keymap.set("n", "grd", vim.lsp.buf.definition)
	end,
})

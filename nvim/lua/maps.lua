vim.keymap.set("n", "<leader>e", require("netrw").toggle_netrw, { desc = "Toggle Netrw" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up" })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Telescope
local tb = require("telescope.builtin")

vim.keymap.set("n", "<leader>b", tb.buffers, { desc = "[B]uffers" })
vim.keymap.set("n", "<leader>s", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	tb.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		previewer = false,
	}))
end, { desc = "[S]earch in current buffer" })

vim.keymap.set("n", "<leader>f", tb.find_files, { desc = "[F]iles" })
vim.keymap.set("n", "<leader>g", tb.git_files, { desc = "[G]it" })

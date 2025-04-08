-- Netrw toggle
local netrw = require("netrw")
vim.keymap.set("n", "<leader>e", netrw.toggle_netrw, { desc = "Toggle Netrw" })

-- Move text up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up" })

-- Join lines and keep cursor position
vim.keymap.set("n", "J", "mzJ`z")

-- Scrolling with center alignment
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search next/previous and center the result
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Navigate between buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Telescope keybindings
local tb = require("telescope.builtin")

-- Buffers
vim.keymap.set("n", "<leader>b", tb.buffers, { desc = "[B]uffers" })

-- Search in current buffer
vim.keymap.set("n", "<leader>s", function()
	tb.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		previewer = false,
	}))
end, { desc = "[S]earch in current buffer" })

-- Find files
vim.keymap.set("n", "<leader>f", tb.find_files, { desc = "[F]iles" })

-- Git files
vim.keymap.set("n", "<leader>g", tb.git_files, { desc = "[G]it" })

-- Live Grep (Search across the entire project)
vim.keymap.set("n", "<leader>l", tb.live_grep, { desc = "[L]ive grep" })

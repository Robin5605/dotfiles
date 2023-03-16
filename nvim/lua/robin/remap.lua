vim.g.mapleader = " " 
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>t", "<cmd>TroubleToggle document_diagnostics<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeFocus<cr>", {silent = true, noremap = true})

vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true })

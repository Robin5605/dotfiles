local opts = { silent = false, noremap = false}

vim.g.mapleader = " " 
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, opts)
vim.keymap.set("n", "<leader>t", "<cmd>TroubleToggle document_diagnostics<cr>", opts)
vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeFocus<cr>", opts)

vim.keymap.set("i", "jk", "<ESC>", opts)

vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

vim.keymap.set("n", "<leader>c", "<cmd>TagbarOpen j<cr>", opts)
vim.g.tagbar_autoclose = 0
vim.g.tagbar_visibility_symbols = { public='󰆧 ', protected='#', private='-' }


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
vim.keymap.set('n', '<leader>gr', builtin.lsp_references, opts)
vim.keymap.set('n', '<leader>tt', builtin.diagnostics, opts)
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, opts)
vim.keymap.set('n', '<leader>lg', builtin.live_grep, opts)

harpoon_mark = require("harpoon.mark")
harpoon_ui = require("harpoon.ui")

vim.keymap.set('n', '<leader>m', harpoon_mark.add_file, {})
vim.keymap.set('n', '<leader>h', harpoon_ui.toggle_quick_menu, {})

vim.keymap.set('n', '<leader>o', function() require("oil").toggle_float(".") end)

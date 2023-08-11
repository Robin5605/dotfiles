require'barbar'.setup({})

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<C-a>", "<Cmd>BufferPrevious<Cr>", opts)
vim.keymap.set("n", "<C-d>", "<Cmd>BufferNext<Cr>", opts)

vim.keymap.set("n", "<C-1>", "<Cmd>BufferGoto 1<Cr>", opts)
vim.keymap.set("n", "<C-2>", "<Cmd>BufferGoto 2<Cr>", opts)
vim.keymap.set("n", "<C-3>", "<Cmd>BufferGoto 3<Cr>", opts)
vim.keymap.set("n", "<C-4>", "<Cmd>BufferGoto 4<Cr>", opts)
vim.keymap.set("n", "<C-5>", "<Cmd>BufferGoto 5<Cr>", opts)
vim.keymap.set("n", "<C-6>", "<Cmd>BufferGoto 6<Cr>", opts)
vim.keymap.set("n", "<C-7>", "<Cmd>BufferGoto 7<Cr>", opts)
vim.keymap.set("n", "<C-8>", "<Cmd>BufferGoto 8<Cr>", opts)
vim.keymap.set("n", "<C-9>", "<Cmd>BufferGoto 9<Cr>", opts)

vim.keymap.set("n", "<C-S-C>", "<Cmd>BufferClose<Cr>", opts)

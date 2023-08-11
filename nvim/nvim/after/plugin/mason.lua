require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = {
        'rust_analyzer',
        'pyright',
        'tsserver',
    }
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')
lspconfig.pyright.setup{
    capabilities = lsp_capabilities,
    settings = {
        python = {
            venvPath = ".",
            analysis = {
                typeCheckingMode = "basic"
            },
        }
    }
}

lspconfig.tsserver.setup{
    capabilities = lsp_capabilities,
}

lspconfig.tailwindcss.setup{
    capabilities = lsp_capabilities,
}

lspconfig.rust_analyzer.setup{
    capabilities = lsp_capabilities,
}

lspconfig.prismals.setup{
    capabilities = lsp_capabilities,
}

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

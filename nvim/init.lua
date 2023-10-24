local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
    "folke/tokyonight.nvim",
    "ThePrimeagen/harpoon",
    "nvim-tree/nvim-web-devicons",
    { 
        "folke/trouble.nvim", 
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            mode = "document_diagnostics",
        }
    },
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter/nvim-treesitter" } },
    "ray-x/lsp_signature.nvim",
    "romgrk/barbar.nvim",
    { 
        "nvim-telescope/telescope.nvim", 
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            pickers = {
                find_files = { hidden = false },
            }
        }
    },

    "williamboman/mason.nvim",
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function(_, _)
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

            mason.setup()

            mason_lspconfig.setup({
                ensure_installed = { "rust_analyzer" },
            })

            local handlers =  {
                ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = "single"}),
                ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = "single"}),
            }

            for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
                lspconfig[server_name].setup({
                    capabilities = lsp_capabilities,
                    handlers = handlers,
                })
            end
        end
    },

    { 
        "hrsh7th/nvim-cmp",
        config = function(_, _)
            local cmp = require("cmp")

            cmp.setup {
                sources = {
                    { name = "nvim_lsp" },
                },
                window = {
                    completion = { border = "rounded" },
                    documentation = { border = "rounded" },
                },
                mapping = {
                    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
                    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
                }
            }
        end
    },

    "preservim/tagbar",
    { 
        "nvim-treesitter/nvim-treesitter", 
        build = ":TSUpdate",
        lazy = false,
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

            ensure_installed = { 
                "c", 
                "lua", 
                "vim", 
                "vimdoc", 
                "javascript", 
                "typescript", 
                "rust", 
                "python", 
                "tsx", 
                "html", 
                "json", 
                "yaml", 
                "toml",
                "query",
            },

            sync_install = false,

            auto_install = true,

            autotag = {
                enable = true,
            }
        },

        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end
    },

})

vim.o.termguicolors = true
vim.cmd.colorscheme("tokyonight")

vim.g.mapleader = " "
require("remap")
require("set")

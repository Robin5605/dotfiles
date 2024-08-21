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
    {
        "windwp/nvim-ts-autotag",
        config = true,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                }
            }
        },
        dependencies = {
            "MunifTanjim/nui.nvim"
        }
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = { modes = { char = { enabled = false } } },
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "t", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        }
    },
    {
    'stevearc/oil.nvim',
      opts = {},
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    "tpope/vim-dadbod",
    "ThePrimeagen/harpoon",
    "nvim-tree/nvim-web-devicons",
    "tpope/vim-fugitive",
    { 
        "L3MON4D3/LuaSnip",
        version = "v2.*",
    },
    {
        "lervag/vimtex",
        init = function()
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_view_method = "zathura"
        end
    },
    { 
        "folke/trouble.nvim", 
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        keys = {
            {
                "<leader>n",
                "<cmd>Trouble diagnostics open<cr>",
                desc = "Diagnostics (Trouble)"
            },
        },
        opts = {
            mode = "diagnostics",
            focus = true,
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
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
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

            local on_attach = function(client, bufnr)
                if client.name == 'ruff' then
                    -- Disable hover in favor of Pyright
                    client.server_capabilities.hoverProvider = false
                end
            end

            lspconfig.rust_analyzer.setup {
                capabilities = lsp_capabilities,
                handlers = handlers,
            }

            lspconfig.ruff.setup {
                on_attach = on_attach
            }

            lspconfig.tsserver.setup {
                capabilities = lsp_capabilities,
                handlers = handlers,
            }

            lspconfig.clangd.setup {
                capabilities = lsp_capabilities,
                handlers = handlers,
            }

            lspconfig.pyright.setup {
                capabilities = lsp_capabilities,
                handlers = handlers,
                settings = {
                    pyright = {
                        -- Using Ruff's import organizer
                        disableOrganizeImports = true,
                    },
                },
            }
        end
    },

    { 
        "hrsh7th/nvim-cmp",
        config = function(_, _)
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = {
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                },
                window = {
                    completion = { border = "rounded" },
                    documentation = { border = "rounded" },
                },
                mapping = {
                    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
                    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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

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
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
        "lewis6991/gitsigns.nvim",
        config = true,
        opts = {
            -- signs_staged_enable = false,
            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')

                local function map(mode, l, r, opts)
                  opts = opts or {}
                  opts.buffer = bufnr
                  vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                  if vim.wo.diff then
                    vim.cmd.normal({']c', bang = true})
                  else
                    gitsigns.nav_hunk('next')
                  end
                end)

                map('n', '[c', function()
                  if vim.wo.diff then
                    vim.cmd.normal({'[c', bang = true})
                  else
                    gitsigns.nav_hunk('prev')
                  end
                end)

                -- Actions
                map('n', '<leader>hs', gitsigns.stage_hunk)
                map('n', '<leader>hr', gitsigns.reset_hunk)
                map('v', '<leader>hs', function() gitsigns.stage_hunk {0, 20}; print("Staged 0 to 20, mode: " .. vim.fn.mode()); end)
                map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                map('n', '<leader>hS', gitsigns.stage_buffer)
                map('n', '<leader>hu', gitsigns.undo_stage_hunk)
                map('n', '<leader>hR', gitsigns.reset_buffer)
                map('n', '<leader>hp', gitsigns.preview_hunk)
                map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
                map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
                map('n', '<leader>hd', gitsigns.diffthis)
                map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
                map('n', '<leader>td', gitsigns.toggle_deleted)

                -- Text object
                map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
        }
    },
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
        enable = false,
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                }
            },
            routes = {
                {
                    view = "notify",
                    filter = { event = "msg_showmode"}
                },
            },
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
        }
    },
    {
    'stevearc/oil.nvim',
      opts = {
          keymaps = {
              ["q"] = {"actions.close", mode = "n"}
          }
      },
      dependencies = { "nvim-tree/nvim-web-devicons" },
      lazy = false,
    },
    "tpope/vim-dadbod",
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = { 'tpope/vim-dadbod', 'kristijanhusak/vim-dadbod-completion' },
        cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection'},
    },
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

            lspconfig.hls.setup {
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
        },

        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end
    },

})

vim.o.termguicolors = true
vim.cmd.colorscheme("catppuccin")

vim.g.mapleader = " "
require("remap")
require("set")

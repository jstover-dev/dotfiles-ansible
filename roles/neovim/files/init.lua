-- Options
-------------------------------------------------------------------------------

vim.o.hidden = true -- Allow switching buffer when current is unwritten
vim.o.number = true -- Show line numbers

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.expandtab = true

vim.o.wrap = false -- Do not wrap lines by default
vim.o.linebreak = true -- When wrap is on, break on words not characters

vim.o.cursorline = true -- Highlight the current line
vim.o.termguicolors = true -- Enable 24-bit RGB colors

-- Map Leader Keys
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Set Python path (assumes an env exists in ~/.envs/nvim)
vim.g.python3_host_prog = os.getenv("HOME") .. "/.envs/nvim/bin/python"

-- Keybindings
-------------------------------------------------------------------------------

--vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true, buffer = bufnr })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, bufopts)


-- Ctrl-n toggles between relative and absolute line numbers
vim.keymap.set("n", "<C-n>", function()
    vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })

-- Toggle virtual_lines with gK
vim.keymap.set("n", "gK", function()
    vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
end, { desc = "Toggle diagnostic virtual_lines" })

if vim.g.vscode then
    -- undo/REDO via vscode
    vim.keymap.set("n", "u", "<Cmd>call VSCodeNotify('undo')<CR>")
    vim.keymap.set("n", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")
    return
end

-- Diagnostics
-------------------------------------------------------------------------------
vim.diagnostic.enable = true
vim.diagnostic.config({
    jump = { float = true },
})

-- lazy.nvim
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key ..." },
        }, true, {})
        vim.fn.getchar()
        ---os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
                

-- Plugins
-------------------------------------------------------------------------------
require("lazy").setup({
    spec = {
        {
            "ViViDboarder/wombat.nvim",
            lazy = false,
            priority = 1000,
            enabled = false,
            config = function()
                vim.cmd([[colorscheme wombat_lush]])
            end,
            dependencies = {
                "rktjmp/lush.nvim",
            },
        },
        {
            "catppuccin/nvim",
            name = "catppuccin",
            lazy = false,
            priority = 1000,
            init = function()
                require("catppuccin").setup({
                    flavour = "macchiato",
                })
                vim.cmd.colorscheme("catppuccin")
            end,
        },

        {
            -- https://github.com/ms-jpq/coq_nvim
            "neovim/nvim-lspconfig",
            lazy = false,
            dependencies = {
                { "ms-jpq/coq_nvim", branch = "coq" },

                -- Snippets
                --{ "ms-jpq/coq.artifacts", branch = "artifacts" },

                -- Lua and 3rdParty such as nvimLUA. Configured below.
                { "ms-jpq/coq.thirdparty", branch = "3p" },
            },
            init = function()
                vim.g.coq_settings = {
                    auto_start = true,
                }
                -- Configure the 3rdParty plugin
                require("coq_3p")({
                    { src = "nvimlua", short_name = "nLUA" },
                })
            end,

            config = function()
                -- Configure LSP
                local coq = require("coq")
                vim.lsp.config("basedpyright", {
                    settings = {
                        basedpyright = {
                            analysis = {
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "openFilesOnly",
                                diagnosticSeverityOverrides = {
                                    reportUnusedCallResult = false,
                                },
                            },
                        },
                    },
                })
                vim.lsp.enable("basedpyright")
            end,
        },
        {
            -- https://github.com/romgrk/barbar.nvim
            "romgrk/barbar.nvim",
            dependencies = {
                "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
                "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
            },
            init = function()
                vim.g.barbar_auto_setup = false
                vim.api.nvim_set_keymap("n", "<A-,>", "<Cmd>BufferPrevious<CR>", { noremap = true, silent = true })
                vim.api.nvim_set_keymap("n", "<A-.>", "<Cmd>BufferNext<CR>", { noremap = true, silent = true })
                vim.api.nvim_set_keymap("n", "<A-c>", "<Cmd>BufferClose<CR>", { noremap = true, silent = true })
            end,
            opts = {},
            version = "^1.0.0", -- optional: only update when a new 1.x version is released
        },
        {
            -- https://github.com/ms-jpq/chadtree
            "ms-jpq/chadtree",
            lazy = false,
            branch = "chad",
            build = "python3 -m chadtree deps",
            cmd = { "CHADopen", "CHADtoggle", "CHADhelp" }, -- Only required for lazy-loading
            init = function()
                -- Toggle with <leader> v
                vim.keymap.set("n", "<leader>v", "<cmd>CHADopen<CR>", { noremap = true, silent = true })
                -- Set options
                vim.api.nvim_set_var("chadtree_settings", {
                    ["ignore.name_glob"] = {
                        "__pycache__",
                    },
                    ["view.width"] = 30,
                })
                -- Auto close if tree is the only window open
                vim.api.nvim_create_autocmd("BufEnter", {
                    pattern = "*",
                    callback = function()
                        if vim.fn.winnr("$") == 1 and vim.bo.filetype == "CHADTree" then
                            vim.cmd("quit")
                        end
                    end,
                })
            end,
        },
        {
            -- https://github.com/nvim-lualine/lualine.nvim
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            init = function()
                require("lualine").setup({
                    options = {
                        theme = "codedark",
                    },
                })
            end,
        },
    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },

    -- automatically check for plugin updates
    checker = { enabled = true, notify = false },
})

-- Autocommands
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufNewFile", {
    group = vim.api.nvim_create_augroup("templates", { clear = true }),
    desc = "Load template",
    callback = function(args)
        local templates = (os.getenv("XDG_CONFIG_HOMES") or (os.getenv("HOME") .. "/.config")) .. "/nvim/templates/"
        local fname = vim.fn.fnamemodify(args.file, ":t")
        local tplExact = templates .. fname .. ".tpl"
        if vim.uv.fs_stat(tplExact) then
            vim.cmd("0r " .. tplExact)
            vim.cmd("$")
            return
        end
        local ext = vim.fn.fnamemodify(args.file, ":e")
        local tplExt = templates .. ext .. ".tpl"
        if vim.uv.fs_stat(tplExt) then
            vim.cmd("0r " .. tplExt)
            vim.cmd("$")
            return
        end
    end,
})

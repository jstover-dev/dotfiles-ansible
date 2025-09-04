-- vim: foldmethod=marker

--: Options {{{
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

--: }}}

--: Keybindings {{{
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

--: }}}

--: Diagnostics {{{
-------------------------------------------------------------------------------
vim.diagnostic.enable = true
vim.diagnostic.config({
    jump = { float = true },
})
--: }}}

--: Utility Functions {{{
--- Replace existing commands with another command
--- @param cmds string[] list of command names to override (e.g. {"help", "h"})
--- @param target string the command to run instead (e.g. "FloatingHelp")
function ReplaceCommands(cmds, target)
    for _, cmd in ipairs(cmds) do
        -- User commands must start with uppercase
        if cmd:match("^[A-Z]") then
            pcall(vim.api.nvim_del_user_command, cmd)
            vim.api.nvim_create_user_command(cmd, function(opts)
                vim.cmd(target .. " " .. (opts.args or ""))
            end, { nargs = "*", force = true })
        -- Fall back to cabbrev expensions
        else
            vim.cmd(string.format(
                [[
                cabbrev %s <c-r>=(getcmdpos() == 1 && getcmdtype() == ":" ? "%s" : "%s")<CR>
            ]],
                cmd,
                target,
                cmd
            ))
        end
    end
end

--: }}}

--: Plugins {{{
-------------------------------------------------------------------------------

-- Bootstrap lazy.nvim
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

-- Plugin setup
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
                    auto_integrations = true,
                    transparent_background = true,
                })
                vim.cmd.colorscheme("catppuccin")
            end,
        },

--        {
--            -- https://github.com/ms-jpq/coq_nvim
--            "ms-jpq/coq_nvim",
--            branch = "coq",
--            build = ":COQdeps",
--        },


        {
            -- https://github.com/ms-jpq/coq_nvim
            "neovim/nvim-lspconfig",
            lazy = false,
            dependencies = {
                { "ms-jpq/coq_nvim", branch = "coq", build = ":COQdeps" },

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
            -- https://github.com/nvim-tree/nvim-tree.lua
            "nvim-tree/nvim-tree.lua",
            version = "*",
            lazy = false,
            dependencies = {
                "nvim-tree/nvim-web-devicons",
            },
            keys = {
                {"<leader>v", "<cmd>NvimTreeToggle<CR>", desc="Toggle nvim-tree panel", noremap=true, silent=true},
            },
            opts = {
                sync_root_with_cwd = true,
                filters = {
                    git_ignored = true,
                    custom = {
                        "^.git$",
                        "node_modules",
                    },
                },
                renderer = {
                    icons = {
                        show = {
                            git = true,
                        },
                        glyphs = {
                            git = {
                                unstaged = "!",
                                staged = "+",
                                deleted = "✘",
                                renamed = "»",
                                untracked = "?",
                            },
                        },
                    },
                },
            },
        },

        {
            -- https://github.com/Tyler-Barham/floating-help.nvim
            "Tyler-Barham/floating-help.nvim",
            lazy = false,
            config = function()
                vim.keymap.set(
                   "n",
                   "<F1>",
                   "<cmd>FloatingHelp<CR>",
                   { noremap = true, silent = true, desc = "Floating help" }
                )
                ReplaceCommands({ "help", "h" }, "FloatingHelp")
                ReplaceCommands({ "helpc", "helpclose" }, "FloatingHelpClose")
            end,
        },

        {
            -- https://github.com/romgrk/barbar.nvim
            "romgrk/barbar.nvim",
            lazy = false,
            version = "^1.0.0", -- optional: only update when a new 1.x version is released
            dependencies = {
                "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
                "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
            },
            opts = {
                sidebar_filetypes = {
                    NvimTree = {
                        text = "NvimTree",
                        align = "center",
                    },
                },
            },
            keys = {
                {"<A-n>", ":tabnew<CR>", noremap = true, silent = true},
                {"<A-,>", "<Cmd>BufferPrevious<CR>", noremap = true, silent = true},
                {"<A-.>", "<Cmd>BufferNext<CR>", noremap = true, silent = true},
                {"<A-c>", "<Cmd>BufferClose<CR>", noremap = true, silent = true},
            },
        },
        {
            -- https://github.com/ms-jpq/chadtree
            "ms-jpq/chadtree",
            enabled = false,
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
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = {
                { "nvim-lua/plenary.nvim" },
                {
                    -- Use Alternate repo until fix is merged:
                    -- https://github.com/nvim-telescope/telescope-fzf-native.nvim/pull/151
                    --"nvim-telescope/telescope-fzf-native.nvim",
                    --branch = "archlinux-fix"
                    "sudonym1/telescope-fzf-native.nvim",
                    commit = "bc876d5a089558caf2266d2022131fa3ed3442ce",
                    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
                },
                { "nvim-tree/nvim-web-devicons", opts = {} },
            },
            opts = {
                defauts = {
                    mappings = {
                        i = {
                            ["<CR>"] = "select_tab",
                        },
                    },
                },
            },
        },

        {
            -- https://github.com/pablos123/shellcheck.nvim
            "pablos123/shellcheck.nvim",
            config = function ()
                require ("shellcheck-nvim").setup({
                    shellcheck_options = {
                        "--external-sources",
                        "--enable=all",
                    },
                })
            end
        },


        {
            -- https://github.com/nvim-lualine/lualine.nvim
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            opts = {
                options = {
                    theme = "codedark",
                },
            },
        },

        {
            -- https://github.com/akinsho/toggleterm.nvim
            "akinsho/toggleterm.nvim",
            version = "^2.0.0",
            opts = {
                open_mapping = [[<c-\>]],
                size = 15,
            },
        },
    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },

    -- automatically check for plugin updates
    checker = { enabled = true, notify = false },
})

--: }}}

--: Autocommands {{{
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

--: }}}

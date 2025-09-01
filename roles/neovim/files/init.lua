vim.o.hidden = true          -- Allow switching buffer when current is unwritten
vim.o.number = true          -- Show line numbers

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.expandtab = true

vim.o.wrap = false          -- Do not wrap lines by default
vim.o.linebreak = true      -- When wrap is on, break on words not characters

vim.o.cursorline = true     -- Highlight the current line
--vim.o.termguicolors = true  -- Enable 24-bit RGB colors


-- Map Leader Keys
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"


-- Set Python path (assumes an env exists in ~/.envs/nvim)
vim.g.python3_host_prog = "~/.envs/nvim/bin/python"


-- Ctrl-n toggles between relative and absolute line numbers
vim.keymap.set("n", "<C-n>", function()
    vim.wo.relativenumber = not vim.wo.relativenumber
end)



if vim.g.vscode then
    -- undo/REDO via vscode
    vim.keymap.set("n","u","<Cmd>call VSCodeNotify('undo')<CR>")
    vim.keymap.set("n","<C-r>","<Cmd>call VSCodeNotify('redo')<CR>")
    return
end


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

-- Configure lazy.nvim
require("lazy").setup({
    spec ={
        {
            "ViViDboarder/wombat.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd([[colorscheme wombat_lush]])
            end,
            dependencies = {
                "rktjmp/lush.nvim"
            }
        },
        {
            -- https://github.com/ms-jpq/coq_nvim
            "neovim/nvim-lspconfig",
            lazy = false,
            dependencies = {
                { "ms-jpq/coq_nvim", branch = "coq" },
                { "ms-jpq/coq.artifacts", branch = "artifacts" },
                { 'ms-jpq/coq.thirdparty', branch = "3p" }

            },
            init = function()
                vim.g.coq_settings = {
                    auto_start = true
                }
            end,
            config = function()

            end
        },
        {
            -- https://github.com/romgrk/barbar.nvim
            "romgrk/barbar.nvim",
            dependencies = {
                "lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
                "nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
            },
            init = function() vim.g.barbar_auto_setup = false end,
            opts = {
            },
            version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },
    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },

    -- automatically check for plugin updates
    checker = { enabled = true, notify = false },
})


-- Configure coq.thirdparty
require("coq_3p") {
  { src = "nvimlua", short_name = "nLUA" },
}



-- Autocommands

-- Autocommand:  Template new files
vim.api.nvim_create_autocmd("BufNewFile", {
    group = vim.api.nvim_create_augroup("templates", {clear=true}),
    desc = "Load template",
    callback = function(args)
        local templates = ( os.getenv("XDG_CONFIG_HOMES") or (os.getenv("HOME") .. "/.config" ) ) .. "/nvim/templates/"
        local fname = vim.fn.fnamemodify(args.file, ":t")
        local tplExact =  templates .. fname .. ".tpl"
        if vim.uv.fs_stat(tplExact) then
            vim.cmd("0r " .. tplExact)
            vim.cmd("$")
            return
        end
        local ext = vim.fn.fnamemodify(args.file, ":e")
        local tplExt =  templates .. ext .. ".tpl"
        if vim.uv.fs_stat(tplExt) then
            vim.cmd("0r " .. tplExt)
            vim.cmd("$")
            return
        end
    end


})

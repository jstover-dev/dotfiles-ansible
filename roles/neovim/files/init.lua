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

-- Ctrl-n toggles between relative and absolute line numbers
vim.keymap.set("n", "<C-n>", function()
    vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line numbers" })

-- Use Ctrl-/ to toggle comments like vscode
vim.keymap.set("n", "<C-_>", "gcc", {desc="Toggle comment line", remap=true})
vim.keymap.set("v", "<C-_>", "gc", {desc="Toggle comment", remap=true})

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
vim.diagnostic.enable()
vim.diagnostic.config({
    jump = { float = true },
})

require("config")


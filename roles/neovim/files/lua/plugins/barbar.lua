---@type LazyPluginSpec
return {
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
        { "<A-n>", ":tabnew<CR>", noremap = true, silent = true },
        { "<A-,>", "<Cmd>BufferPrevious<CR>", noremap = true, silent = true },
        { "<A-.>", "<Cmd>BufferNext<CR>", noremap = true, silent = true },
        { "<A-c>", "<Cmd>BufferClose<CR>", noremap = true, silent = true },
    },
}

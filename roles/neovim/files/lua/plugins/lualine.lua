---@type LazyPluginSpec
return {
    -- https://github.com/nvim-lualine/lualine.nvim
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        options = {
            --theme = "dracula",
            --theme = "papercolor_dark",
            --theme = "gruvbox_dark",
            theme = "everforest",
            ignore_focus = {
               "NvimTree", 
            },
            disabled_filetypes = {
                'NvimTree',
                'toggleterm',
            }
        },
        sections = { lualine_c = {'%=', '%t%m', '%3p'} }
    },
}

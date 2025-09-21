---@type NvPluginSpec
return {
    {
        -- https://github.com/ViViDboarder/wombat.nvim
        "ViViDboarder/wombat.nvim",
        dependencies = {
            "rktjmp/lush.nvim",
        },
        opts = {
            ansi_colors_name = nil,
        },
    },
    {
        -- https://github.com/catppuccin/nvim
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        opts = {
            flavour = "macchiato",
            auto_integrations = true,
            transparent_background = true,
        },
        init = function()
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    {
        -- https://github.com/zaldih/themery.nvim
        "zaldih/themery.nvim",
        lazy = false,
        config = function()
            require("themery").setup({
                livePreview = true,
                themes = {
                    { name = "Wombat", colorscheme = "wombat_lush" },
                    { name = "Catppuccin", colorscheme = "catppuccin" },
                    { name = "Catppuccin (Frappe)", colorscheme = "catppuccin-frappe" },
                },
            })
        end,
    },
}

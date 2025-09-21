---@type LazyPluginSpec
return {
    -- https://github.com/nvim-tree/nvim-tree.lua
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<leader>v", "<cmd>NvimTreeToggle<CR>", desc = "Toggle nvim-tree panel", noremap = true, silent = true },
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
        actions = {
            open_file = {
                window_picker = {
                    enable = true,
                },
            },
        },
    },
}

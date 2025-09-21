---@type LazyPluginSpec
return {
    -- https://github.com/Tyler-Barham/floating-help.nvim
    "Tyler-Barham/floating-help.nvim",
    lazy = false,
    config = function()
        vim.keymap.set("n", "<F1>", "<cmd>FloatingHelp<CR>", { noremap = true, silent = true, desc = "Floating help" })
        ReplaceCommands({ "help", "h" }, "FloatingHelp")
        ReplaceCommands({ "helpc", "helpclose" }, "FloatingHelpClose")
    end,
}

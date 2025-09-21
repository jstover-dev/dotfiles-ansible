---@type LazyPluginSpec

return {
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
}

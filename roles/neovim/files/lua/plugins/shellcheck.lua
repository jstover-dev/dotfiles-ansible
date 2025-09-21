---@type NvPluginSpec
return {
    -- https://github.com/pablos123/shellcheck.nvim
    "pablos123/shellcheck.nvim",
    config = function()
        require("shellcheck-nvim").setup({
            shellcheck_options = {
                "--external-sources",
                "--enable=all",
                "--source-path=SCRIPTDIR",
            },
        })
    end,
}

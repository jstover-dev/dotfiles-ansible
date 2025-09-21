---@type NvPluginSpec
return {
    -- https://github.com/ms-jpq/coq_nvim
    "ms-jpq/coq_nvim",
    branch = "coq",
    dependencies = {
        -- Snippets
        --{ "ms-jpq/coq.artifacts", branch = "artifacts" },

        -- Lua and 3rdParty such as nvimLUA. Configured below.
        { "ms-jpq/coq.thirdparty", branch = "3p" },

        { "neovim/nvim-lspconfig", version = "2.4.0" },
    },
    build = ":COQdeps",
    init = function()
        vim.g.coq_settings = {
            auto_start = true,
            clients = {
                snippets = {
                    warn = {},
                },
            },
        }
        -- Configure the 3rdParty plugin
        require("coq_3p")({
            { src = "nvimlua", short_name = "nLUA" },
        })
    end,
    config = function()
        require("lsp")

        --vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true, buffer = bufnr })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    end,
}

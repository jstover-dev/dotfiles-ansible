-- lua/lsp/pyright.lua
return {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "strict",
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                diagnosticSeverityOverrides = {
                    reportUnusedCallResult = false,
                    reportUnknownVariableType = false,
                    reportUnknownMemberType = false,
                },
            },
        },
    },
    on_attach = function(client, bufnr)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { buffer = bufnr })
    end,
}

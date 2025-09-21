local lsp_manager = require("lsp.manager")

lsp_manager.enable("basedpyright")
lsp_manager.enable("lua_ls")
lsp_manager.enable("gopls")

lsp_manager.enable("ts_ls")
lsp_manager.enable("rust_analyzer")
lsp_manager.enable("clangd")
lsp_manager.enable("solargraph")
lsp_manager.enable("intelephense")
lsp_manager.enable("html")
lsp_manager.enable("cssls")
lsp_manager.enable("jsonls")



-- auto-start LSP per filetype
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("LspAutoStart", { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local ft = vim.bo[bufnr].filetype

        -- Start LSP using the configs from lsp_manager
        for name, conf in pairs(lsp_manager.get_for_filetype(ft)) do
            vim.lsp.start({
                name = name,
                cwd = vim.fs.dirname(bufname),
                bufnr = bufnr,
                cmd = conf.cmd,
                settings = conf.settings,
                root_dir = conf.root_dir and conf.root_dir(bufname),
                on_attach = conf.on_attach,
                capabilities = vim.deepcopy(conf.capabilities or {}),
            })
        end

    end,
})

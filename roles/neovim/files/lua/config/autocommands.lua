vim.api.nvim_create_autocmd("BufNewFile", {
    group = vim.api.nvim_create_augroup("templates", { clear = true }),
    desc = "Load template",
    callback = function(args)
        local templates = (os.getenv("XDG_CONFIG_HOMES") or (os.getenv("HOME") .. "/.config")) .. "/nvim/templates/"
        local fname = vim.fn.fnamemodify(args.file, ":t")
        local tplExact = templates .. fname .. ".tpl"
        if vim.uv.fs_stat(tplExact) then
            vim.cmd("0r " .. tplExact)
            vim.cmd("$")
            return
        end
        local ext = vim.fn.fnamemodify(args.file, ":e")
        local tplExt = templates .. ext .. ".tpl"
        if vim.uv.fs_stat(tplExt) then
            vim.cmd("0r " .. tplExt)
            vim.cmd("$")
            return
        end
    end,
})

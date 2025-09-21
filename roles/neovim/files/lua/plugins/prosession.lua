return {
    "dhruvasagar/vim-prosession",
    dependencies = {
        "tpope/vim-obsession",
    },
    init = function()
        vim.g.prosession_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'session');
        vim.g.prosession_per_branch = 1
        
    end
}

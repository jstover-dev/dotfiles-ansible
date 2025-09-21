local M = {}

local configs_module = "lsp.configs"

M.servers = {}

---@param name string
function M.enable(name)
    -- Skip if already enabled
    if M.servers[name] then
        return
    end

    local config = {}

    -- Get default config
    local config_def = require("lspconfig")[name].config_def
    if config_def ~= nil then
        config = config_def.default_config
    end

    -- Try import from local lsp directory
    local exists, local_config = pcall(require, string.format("%s.%s", configs_module, name))
    if exists then
        vim.tbl_deep_extend("force", config, local_config)
    end

    if next(config) == nil then
        error(string.format("No configuration found for server: %s", name))
    end

    vim.lsp.config[name] = vim.lsp.config[name] or {}
    vim.tbl_deep_extend("force", vim.lsp.config[name], config)
    M.servers[name] = vim.lsp.config[name]
    --vim.print(string.format("Registered LSP Server %s", server.name))
    --vim.print(vim.lsp.config[server.name])
end

---@param ft string
function M.get_for_filetype(ft)
    local servers = {}
    for name, conf in pairs(M.servers) do
        if conf.filetypes and vim.tbl_contains(conf.filetypes, ft) then
            servers[name] = conf
        end
    end
    return servers
end

return M

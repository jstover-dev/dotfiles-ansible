-- generate_ft_map.lua
--
-- Run this with:
--    nvim --headless -u ~/.config/nvim/init.lua -l lua/scripts/generate-lsp-ft-map.lua

local ignored = {
    ["volar"] = true,
}

local plugin_path = vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lsp/"

local filetype_map = {}

for _, file in ipairs(vim.fn.glob(plugin_path .. "*.lua", true, true)) do
    local name = file:match("([^/]+)%.lua$")
    if not ignored[name] then
        local conf = vim.lsp.config[name]
        for _, ft in ipairs(conf.filetypes or {}) do
            filetype_map[ft] = filetype_map[ft] or {}
            table.insert(filetype_map[ft], name)
        end
    end
end

-- Print as Lua table
print("return " .. vim.inspect(filetype_map))

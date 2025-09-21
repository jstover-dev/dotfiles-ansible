local open_windows_picker = function(opts)
    local telescope = require("telescope")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    opts = opts or {}

    -- Build map of ignored filetypes for easier lookup
    ignore_filetypes = {}
    for _, ft in ipairs(opts.ignore_filetypes or {}) do
        ignore_filetypes[ft] = true
    end

    -- Build list of windows
    local entries = {}

    -- For each tab
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        local tab_pages = vim.api.nvim_tabpage_list_wins(tab)
        local tab_nr = vim.api.nvim_tabpage_get_number(tab)
        -- For each window
        for _, win in ipairs(tab_pages) do
            if vim.api.nvim_win_is_valid(win) then
                local buf = vim.api.nvim_win_get_buf(win)
                local buf_name = vim.api.nvim_buf_get_name(buf) or "[No Name]"
                local short_name = vim.fn.fnamemodify(buf_name, ":p:t") ~= "" and vim.fn.fnamemodify(buf_name, ":p:t")
                    or "[No Name]"
                local buf_ft = string.format("ft=%s", vim.fn.getbufvar(buf, "&filetype"))

                local entry = {
                    value = tostring(win),
                    display = string.format(
                        "Tab %d | Win %d | %-15s | %s (%s)",
                        tab_nr,
                        win,
                        buf_ft,
                        short_name,
                        buf_name
                    ),
                    ordinal = string.format("%s %s %d", short_name, buf_name, tab_nr),
                }

                if not ignore_filetypes[buf_ft] then
                    table.insert(entries, entry)
                end
            end
        end
    end

    -- Create picker
    pickers
        .new(opts, {
            prompt_title = "Open Windows",
            finder = finders.new_table({
                results = entries,
                entry_maker = function(entry)
                    return entry
                end,
            }),
            --sorter = conf.generic_sorter(opts),
            -- attach_mappings = function(prompt_bufnr, map)
            --     -- On selection: focus the chosen window
            --     -- actions.set_default_selection(prompt_bufnr, function()
            --     --   local selection = action_state.get_selected_entry()
            --     --   if selection and selection.value then
            --     --     vim.api.nvim_set_current_win(selection.value)
            --     --   end
            --     --   require("telescope.actions").close(prompt_bufnr)
            --     -- end)
            --
            --     return true
            -- end,
        })
        :find()
end


---@type LazyPluginSpec
return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
            -- Use Alternate repo until fix is merged:
            -- https://github.com/nvim-telescope/telescope-fzf-native.nvim/pull/151
            --"nvim-telescope/telescope-fzf-native.nvim",
            --branch = "archlinux-fix"
            "sudonym1/telescope-fzf-native.nvim",
            commit = "bc876d5a089558caf2266d2022131fa3ed3442ce",
            build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
        },
        { "nvim-tree/nvim-web-devicons", opts = {} },
    },
    config = function()
        local telescope = require("telescope")
        --local open_windows = require("plugins.telescope.open_windows")

        telescope.setup({
            -- defauts = {
            --     mappings = {
            --         i = {
            --             ["<CR>"] = "select_tab",
            --         },
            --     },
            -- },
        })

        vim.api.nvim_create_user_command("TelescopeOpenWindows", function()
            open_windows_picker({
                --open_windows({
                ignore_filetypes = { "NvimTree" },
            })
        end, {})
    end,
}

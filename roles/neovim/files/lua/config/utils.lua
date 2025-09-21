--- Replace existing commands with another command
--- @param cmds string[] list of command names to override (e.g. {"help", "h"})
--- @param target string the command to run instead (e.g. "FloatingHelp")
function ReplaceCommands(cmds, target)
    for _, cmd in ipairs(cmds) do
        -- User commands must start with uppercase
        if cmd:match("^[A-Z]") then
            pcall(vim.api.nvim_del_user_command, cmd)
            vim.api.nvim_create_user_command(cmd, function(opts)
                vim.cmd(target .. " " .. (opts.args or ""))
            end, { nargs = "*", force = true })
        -- Fall back to cabbrev expensions
        else
            vim.cmd(string.format(
                [[
                cabbrev %s <c-r>=(getcmdpos() == 1 && getcmdtype() == ":" ? "%s" : "%s")<CR>
            ]],
                cmd,
                target,
                cmd
            ))
        end
    end
end

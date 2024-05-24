--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- patterns.lua
--

local M = {}

local Pattern = {
    { name = "%", action = nil },
    { name = "ft", action = nil },
    { name = "f", action = nil },
    { name = "n", action = nil },
    { name = "p", action = nil },
    { name = "h", action = nil },
    { name = "gp", action = nil },
    { name = "g", action = nil },
    { name = "dd", action = nil },
    { name = "mm", action = nil },
    { name = "yyyy", action = nil },
    { name = "yy", action = nil },
    { name = "su", action = nil },
    { name = "m", action = nil },
    { name = "u", action = nil },
    { name = "e", action = nil },
}

---@param match string
---@return table|nil
function Pattern:find(match)
    for _, p in pairs(self) do
        if type(p) ~= "table" then
            if string.sub(match, 1, #p.name) == p.name then
                return p
            end
        end
    end
    return nil
end

---@param template string
---@return string|nil
M.format = function(template)
    if string.find(template, "%%") == nil then
        return template
    end

    local matches = {}
    for m in string.gmatch(template, "([^%%]+)") do
        table.insert(matches, m)
    end
    if string.sub(template, 1, 1) ~= "%" then
        table.remove(matches, 1)
    end

    for _, m in pairs(matches) do
        local pattern = Pattern:find(m)
        assert(pattern ~= nil, string.format("Pattern invalid: %.10s", m))

        print(vim.inspect(pattern))
    end
    return template
end

return M

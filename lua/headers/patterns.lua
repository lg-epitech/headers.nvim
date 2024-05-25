--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- patterns.lua
--

local M = {}

-- NOTE: Patterns

---@class Pattern
---@field name string
---@field execute function|nil
local Pattern = {}

---@param name string
---@param execute function|nil
---@return Pattern
function Pattern:new(name, execute)
    local newpat = {}

    newpat.name = name or ""
    newpat.execute = execute
    setmetatable(newpat, Pattern)
    return newpat
end

---@return string
Pattern.percent = function()
    return "%"
end

---@return string
Pattern.ft = function()
    return vim.bo.filetype
end

---@return string
Pattern.f = function()
    return vim.fn.expand("%:t")
end

---@return string
Pattern.n = function()
    return vim.fn.expand("%:t:r")
end

---@return string
Pattern.p = function()
    return vim.fn.expand("%:p")
end

---@return string
Pattern.hrp = function()
    return vim.fn.expand("%:p:~")
end

---@return string
Pattern.crp = function()
    return vim.fn.expand("%:.")
end

---@return string
Pattern.grp = function()
    if os.execute("git rev-parse --is-inside-work-tree &> /dev/null") ~= 0 then
        return Pattern.crp()
    end

    local p = vim.api.nvim_buf_get_name(0)
    local GitPath = io.popen("git rev-parse --show-toplevel"):read()

    if string.sub(p, 1, #GitPath) == GitPath then
        return string.sub(p, #GitPath + 2, #p)
    end

    return Pattern.hrp()
end

---@return string
Pattern.g = function()
    if os.execute("git rev-parse --is-inside-work-tree &> /dev/null") ~= 0 then
        return vim.fn.expand("%:h")
    end

    local p = vim.api.nvim_buf_get_name(0)
    local GitPath = io.popen("git rev-parse --show-toplevel"):read()

    if string.sub(p, 1, #GitPath) == GitPath then
        local s = vim.split(GitPath, "/")
        return s[#s]
    end

    return vim.fn.expand("%:h")
end

---@return string
Pattern.dd = function()
    return io.popen("date +%d"):read()
end

---@return string
Pattern.mm = function()
    return io.popen("date +%m"):read()
end

---@return string
Pattern.yyyy = function()
    return io.popen("date +%Y"):read()
end

---@return string
Pattern.yy = function()
    return io.popen("date +%y"):read()
end

---@return string
Pattern.su = function()
    return io.popen("whoami"):read()
end

---@return string
Pattern.m = function()
    return HConfig.email or "Unspecified"
end

---@return string
Pattern.u = function()
    return HConfig.username or "Unspecified"
end

---@return string
Pattern.e = function()
    return vim.fn.expand("%:e")
end

-- NOTE: List of Patterns

---@class pList
local pList = {}

---@param name string
---@param execute function|nil
function pList:addPattern(name, execute)
    table.insert(self, Pattern:new(name, execute))
end

pList:addPattern("yyyy", Pattern.yyyy)
pList:addPattern("hrp", Pattern.hrp)
pList:addPattern("crp", Pattern.crp)
pList:addPattern("grp", Pattern.grp)
pList:addPattern("dd", Pattern.dd)
pList:addPattern("mm", Pattern.mm)
pList:addPattern("yy", Pattern.yy)
pList:addPattern("su", Pattern.su)
pList:addPattern("ft", Pattern.ft)
pList:addPattern("%", Pattern.percent)
pList:addPattern("f", Pattern.f)
pList:addPattern("n", Pattern.n)
pList:addPattern("p", Pattern.p)
pList:addPattern("g", Pattern.g)
pList:addPattern("m", Pattern.m)
pList:addPattern("u", Pattern.u)
pList:addPattern("e", Pattern.e)

---@param match string
---@return Pattern|nil
function pList:find(match)
    if #match == 0 then
        return nil
    end

    for _, p in pairs(self) do
        if type(p) == "table" then
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
    local i = 1
    local result = ""

    while i ~= #template + 1 do
        local c = string.sub(template, i, i)

        if c ~= "%" then
            result = result .. c
        else
            local pattern = pList:find(string.sub(template, i + 1, #template))
            if pattern == nil then
                return nil
            end

            result = result .. pattern.execute()
            i = i + #pattern.name
        end

        i = i + 1
    end
    return result
end

return M

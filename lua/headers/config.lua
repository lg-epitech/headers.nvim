--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- config.lua
--

local comments = require("headers.comments")

---@class HConfig
---@field merge function
---@field email string|nil
---@field username string|nil
---@field comments table<comment>
---@field padding number
---@field separation string
HConfig = {
    comments = comments.list,
    padding = 0,
    separation = " ",
}

---Merges t2 into t1
---@param t1 table
---@param t2 table
---@return table
local function merge_table(t1, t2)
    for name, setting in pairs(t2) do
        if type(setting) == "table" then
            t1[name] = merge_table(t1[name] or {}, setting)
        else
            t1[name] = setting
        end
    end

    return t1
end

---@param UserConfig table
function HConfig:merge(UserConfig)
    HConfig = merge_table(HConfig, UserConfig)
end

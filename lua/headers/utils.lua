--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- utils.lua
--

local comments = require("headers.comments")

local M = {}

---@param name string
---@return string
M.hash_string = function(name)
    return vim.fn.sha256(name)
end

---@return string
M.get_extension = function()
    local ext = vim.fn.expand("%:e")

    if #ext == 0 then
        return vim.fn.expand("%:t:r")
    else
        return ext
    end
end

M.random_extension = function()
    local listIdx = math.random(1, #comments.list)
    local nameIdx = math.random(1, #comments.list[listIdx].names)

    return comments.list[listIdx].names[nameIdx]
end

return M

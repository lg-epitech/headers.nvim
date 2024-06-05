--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- utils.lua
--

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

return M

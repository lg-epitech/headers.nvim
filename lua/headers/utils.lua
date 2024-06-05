--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- utils.lua
--

local M = {}

---@param name string
---@return string
M.sanitize_name = function(name)
    name, _ = string.gsub(name, "\n", "-")
    name, _ = string.gsub(name, " ", "_")
    name, _ = string.gsub(name, "\t", "_")

    name, _ = string.gsub(name, "*", "")
    name, _ = string.gsub(name, "~", "")
    name, _ = string.gsub(name, "/", "")
    name, _ = string.gsub(name, "\\", "")
    name, _ = string.gsub(name, ":", "")
    name, _ = string.gsub(name, "?", "")
    name, _ = string.gsub(name, '"', "")
    name, _ = string.gsub(name, "<", "")
    name, _ = string.gsub(name, ">", "")
    name, _ = string.gsub(name, "|", "")
    return name
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

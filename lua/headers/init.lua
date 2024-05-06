--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- /home/laurent/projects/headers.nvim/lua/headers.nvim/init.lua
--

-- NOTE: This is the default configuration

require("headers.config")

local M = {
    _NAME = "headers.nvim",
    _VERSION = "0.0.0-dev",
    _AUTHOR = "Laurent Gonzalez (lg-epitech)",
    _LICENSE = "MIT License",
}

---@param opts table
M.setup = function(opts)
    HConfig:merge(opts)

    vim.inspect(HConfig)
end

return M

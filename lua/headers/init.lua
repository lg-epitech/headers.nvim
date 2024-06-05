--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- /home/laurent/projects/headers.nvim/lua/headers.nvim/init.lua
--

-- NOTE: This is the default configuration

local path = require("plenary.path")

local M = {
    _NAME = "headers.nvim",
    _VERSION = "0.0.0-dev",
    _AUTHOR = "Laurent Gonzalez (lg-epitech)",
    _LICENSE = "MIT License",
}

---@param opts table
M.setup = function(opts)
    local hPath = path:new(vim.fn.stdpath("data") .. "/headers")
    if hPath:is_dir() == false then
        hPath:mkdir()
    end

    require("headers.config")
    HConfig:merge(opts)

    local templates = require("headers.templates")
    templates:scan()

    require("headers.commands")
end

return M

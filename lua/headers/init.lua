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
    local templates = require("headers.templates")
    local ui = require("headers.ui")
    require("headers.config")
    require("headers.commands")

    if hPath:is_dir() == false then
        hPath:mkdir()
    end

    HConfig:merge(opts)
    templates.scan()
    ui:setup()
end

return M

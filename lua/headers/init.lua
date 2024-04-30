--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- /home/laurent/projects/headers.nvim/lua/headers.nvim/init.lua
--

-- NOTE: This is the default configuration

---@class HConfig
---@field templates_dir string|nil
---@field mapping_options table options given for the user commands
---@field path_sep string "/" for linux and "\\" for w******
HeadersConfig = {
    templates_dir = nil,
    path_sep = "/"
}

local M = {
    _NAME = "headers.nvim",
    _VERSION = "0.0.0-dev",
    _AUTHOR = "Laurent Gonzalez (lg-epitech)",
    _LICENSE = "MIT License",

    ---@param opts HConfig
    setup = function(opts)
        for name, setting in pairs(opts) do
            HeadersConfig[name] = setting
        end

        local utils = require("headers.utils")

        if HeadersConfig.templates_dir == nil or
        utils.is_dir(HeadersConfig.templates_dir) == false then
            print("No/Invalid templates directory specified, please refer to the documentation.")
            return
        end

        -- TODO: Create GUI and user command
        -- require("headers.gui")
    end
}

return M

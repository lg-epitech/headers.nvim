--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- config.lua
--

local path = require("plenary.path")

---@class HConfig
---@field merge function
---@field templates_dir table|nil
---@field email string|nil
---@field username string|nil
HConfig = {}

---@param UserConfig table
function HConfig:merge(UserConfig)
    for name, setting in pairs(UserConfig) do
        self[name] = setting
    end

    self.templates_dir = path:new(self.templates_dir)
end

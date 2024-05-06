--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- config.lua
--

local path = require("plenary.path")

---@class HConfig
---@field templates_dir table|nil
---@field merge function
HConfig = {
    templates_dir = nil,
}

---@param UserConfig table
function HConfig:merge(UserConfig)
    for name, setting in pairs(UserConfig) do
        self[name] = setting
    end

    self.templates_dir = path:new(self.templates_dir)
end

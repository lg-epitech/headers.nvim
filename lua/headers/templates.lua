--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- templates.lua
--

local path = require("plenary.path")

---@class Templates
---@field add function
---@field delete function
local Templates = {}

---@param name string
function Templates:add(name)
    if HConfig.templates_dir == nil or not HConfig.templates_dir:is_dir() then
        print("No/Invalid templates directory specified")
        return
    end

    local new_template_path = path:new(HConfig.templates_dir:joinpath(name))

    if new_template_path:is_dir() then
        -- Maybe make a flag to bypass this
        print("Template already exists.")
        return
    end
    new_template_path:mkdir()
end

---@param name string
function Templates:delete(name)
    if HConfig.templates_dir == nil or not HConfig.templates_dir:is_dir() then
        print("No/Invalid templates directory specified")
        return
    end

    local template_path = path:new(HConfig.templates_dir:joinpath(name))

    if not template_path:is_dir() then
        print("Template doesn't exist.")
        return
    end

    if template_path:rmdir() == nil then
        print("Detected error in removing template " .. name)
    else
        print("Deleted template: " .. name)
    end
end

return Templates

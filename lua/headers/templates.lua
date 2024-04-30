--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- templates.lua
--

local lfs = require("lfs")
local utils = require("headers.utils")

---@class Templates
---@field ls function
local Templates = {}

function Templates:ls()
    if HeadersConfig.templates_dir == nil or
    utils.is_dir(HeadersConfig.templates_dir) == false then
        print("No/Invalid templates directory specified, please refer to the documentation.")
        return
    end

    for template in lfs.dir(HeadersConfig.templates_dir) do
        local template_path = HeadersConfig.templates_dir .. HeadersConfig.path_sep .. template
        if lfs.attributes(template_path, "mode") == "directory" and template:sub(0, 1) ~= "." then
            print(template)
        end
    end
end

---@param name string
function Templates:add(name)
    if HeadersConfig.templates_dir == nil or
    utils.is_dir(HeadersConfig.templates_dir) == false then
        print("No/Invalid templates directory specified, please refer to the documentation.")
        return
    end

    local new_template_path = HeadersConfig.templates_dir .. HeadersConfig.path_sep .. name

    if utils.is_dir(new_template_path) then
        print("Template already exists.") -- Maybe consider making a flag to bypass that check
        return
    end
    lfs.mkdir(new_template_path)
end

---@param name string
function Templates:delete(name)
    if HeadersConfig.templates_dir == nil or
    utils.is_dir(HeadersConfig.templates_dir) == false then
        print("No/Invalid templates directory specified, please refer to the documentation.")
        return
    end

    local template_path = HeadersConfig.templates_dir .. HeadersConfig.path_sep .. name

    if not utils.is_dir(template_path) then
        print("Template doesn't exist.")
        return
    end

    utils.remove_recursively(template_path)
    print("Deleted template: " .. name)
end

return Templates

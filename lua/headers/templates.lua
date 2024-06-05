--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- templates.lua
--

local path = require("plenary.path")
local scan = require("plenary.scandir")
local utils = require("headers.utils")

local storage_path = vim.fn.stdpath("data") .. "/headers"

local M = {}

---@class variant
---@field extension string
---@field replacement string
local variant = {}
variant.__index = variant

---@param extension string
---@param replacement string
---@return variant
function variant:new(extension, replacement)
    local new_variant = {}

    new_variant.extension = extension
    new_variant.replacement = replacement

    setmetatable(new_variant, variant)
    return new_variant
end

---@class template
---@field name string
---@field text string
---@field is_selected boolean
---@field path string
---@field variations table<variant>
local template = {}
template.__index = template

---@param file string
---@return template|nil
function template:scan(file)
    local p = path:new(file)

    local contents = p:read()
    local t = vim.json.decode(contents)

    if
        t.name == nil
        or t.text == nil
        or t.is_selected == nil
        or t.path == nil
        or t.variations == nil
    then
        print(string.format("Found invalid template: %s", file))
        return nil
    end

    setmetatable(t, template)
    return t
end

---@param name string
---@param text string
---@return template
function template:new(name, text)
    local new_template = {}

    new_template.name = name
    new_template.text = text
    new_template.is_selected = false
    new_template.variations = {}

    local p = path:new(storage_path):joinpath(utils.hash_string(name) .. ".txt")
    new_template.path = p.filename

    local contents = vim.json.encode(new_template)
    p:write(contents, "w")
    setmetatable(new_template, template)

    return new_template
end

---@return string
function template:getString()
    local extension = string.lower(utils.get_extension())
    for _, var in ipairs(self.variations) do
        if var.extension == extension then
            return var.replacement
        end
    end

    return self.text
end

---@param extension string
---@param text string
function template:add_variant(extension, text)
    extension = string.lower(extension)
    for _, var in ipairs(self.variations) do
        if var.extension == extension then
            var.replacement = text

            local p = path:new(self.path)

            local contents = vim.json.encode(setmetatable(self, {}))
            p:write(contents, "w")
            setmetatable(self, template)
            return
        end
    end

    table.insert(self.variations, variant:new(extension, text))
    local p = path:new(self.path)

    local contents = vim.json.encode(setmetatable(self, {}))
    setmetatable(self, template)
    p:write(contents, "w")
end

---@type table<template>
M.list = {}

---@param name string
---@return number, template|nil
M.find = function(name)
    for i, templ in ipairs(M.list) do
        if templ.name == name then
            return i, templ
        end
    end

    return 0, nil
end

M.scan = function()
    local list = scan.scan_dir(storage_path, { depth = 1 })

    for _, file in pairs(list) do
        local t = template:scan(file)

        if t ~= nil then
            local i, collision = M.find(t.name)

            if collision ~= nil then
                M.remove(i)
            end

            table.insert(M.list, t)
        end
    end
end

---@return boolean
M.add = function(name, text)
    local i, collision = M.find(name)

    if collision ~= nil then
        M.remove(i)
    end

    local t = template:new(name, text)
    table.insert(M.list, t)

    return true
end

---@param idx number
---@return boolean
M.remove = function(idx)
    local templ = M.list[idx]
    if templ == nil then
        return false
    end

    local tpath = path:new(templ.path)
    tpath:rm()

    table.remove(M.list, idx)

    return true
end

---@return template|nil
M.getSelected = function()
    for _, templ in ipairs(M.list) do
        if templ.is_selected then
            return templ
        end
    end

    return nil
end

---@param name string
---@return boolean
M.select = function(name)
    local curr_selected = M.getSelected()
    local _, templ = M.find(name)

    if templ == nil then
        print(string.format("Could not select %s", name))
        return false
    end

    if curr_selected ~= nil then
        curr_selected.is_selected = false
        if curr_selected.name == name then
            return true
        end
    end

    templ.is_selected = true
    return true
end

---@param template_name string
---@param extension string
---@param text string
---@return boolean
M.add_variant = function(template_name, extension, text)
    local _, templ = M.find(template_name)
    if templ == nil then
        return false
    end

    templ:add_variant(extension, text)

    return true
end

return M

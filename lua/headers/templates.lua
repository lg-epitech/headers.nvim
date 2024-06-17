--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- templates.lua
--

local path = require("plenary.path")
local scan = require("plenary.scandir")
local utils = require("headers.utils")
local patterns = require("headers.patterns")

local storage_path = vim.fn.stdpath("data") .. "/headers"

local M = {}

---@class TemplateVariation
---@field extension string
---@field replacement string
---@field opts table
local _variant = {}
_variant.__index = _variant

---@param extension string
---@param replacement string
---@param opts table
---@return TemplateVariation
function _variant:new(extension, replacement, opts)
    local new_variant = {}

    new_variant.extension = extension
    new_variant.replacement = replacement
    new_variant.opts = opts or {}

    setmetatable(new_variant, _variant --[[@as table]])
    return new_variant
end

---@class Template
---@field name string
---@field text string
---@field is_selected boolean
---@field path string
---@field opts table
---@field variations table<TemplateVariation>
local _template = {}
_template.__index = _template

---@param file string
---@return Template|nil
function _template:scan(file)
    local p = path:new(file)

    local contents = p:read()
    local t = vim.json.decode(contents)

    if
        t.name == nil
        or t.text == nil
        or t.is_selected == nil
        or t.path == nil
        or t.variations == nil
        or t.opts == nil
    then
        print(string.format("Found invalid template: %s", file))
        return nil
    end

    setmetatable(t, _template --[[@as table]])
    return t
end

---@param name string
---@param text string
---@param opts table
---@return Template
function _template:new(name, text, opts)
    local new_template = {}

    new_template.name = name
    new_template.text = text
    new_template.is_selected = false
    new_template.variations = {}
    new_template.opts = opts or {}

    local p = path:new(storage_path):joinpath(utils.hash_string(name) .. ".txt")
    new_template.path = p.filename

    local contents = vim.json.encode(new_template)
    p:write(contents, "w")
    setmetatable(new_template, _template --[[@as table]])

    return new_template
end

---@return string, table
function _template:get_info()
    local extension = string.lower(utils.get_extension())
    for _, var in ipairs(self.variations) do
        if var.extension == extension then
            return var.replacement, var.opts
        end
    end

    return self.text, self.opts
end

---@param extension string
---@param text string
---@param opts table
function _template:add_variant(extension, text, opts)
    extension = string.lower(extension)
    for _, var in ipairs(self.variations) do
        if var.extension == extension then
            var.replacement = text
            var.opts = opts or {}

            self:save()
            return
        end
    end

    table.insert(self.variations, _variant:new(extension, text, opts))
    self:save()
end

function _template:save()
    local p = path:new(self.path)

    local contents = vim.json.encode(setmetatable(self, {}))
    setmetatable(self, _template --[[@as table]])
    p:write(contents, "w")
end

---@type table<Template>
M.list = {}

---@param name string
---@return number, Template|nil
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
        local t = _template:scan(file)

        if t ~= nil then
            table.insert(M.list, t)
        end
    end
end

---@param name string
---@param text string
---@param opts table
---@return boolean
M.add = function(name, text, opts)
    local i, collision = M.find(name)

    if collision ~= nil then
        M.remove(i)
    end

    local t = _template:new(name, text, opts)
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

---@return Template|nil
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
        curr_selected:save()
        if curr_selected.name == name then
            return true
        end
    end

    templ.is_selected = true
    templ:save()
    return true
end

---@param template_name string
---@param extension string
---@param text string
---@param opts table
---@return boolean
M.add_variant = function(template_name, extension, text, opts)
    local _, templ = M.find(template_name)
    if templ == nil then
        return false
    end

    templ:add_variant(extension, text, opts)

    return true
end

M.insert = function()
    local templ = M.getSelected()
    if templ == nil then
        print("You don't have a selected header.")
        return
    end

    local extension = utils.get_extension()
    local template_string, opts = templ:get_info()
    if template_string == nil then
        print("Template string not found.")
        return
    end

    local formatted = patterns.format(template_string)
    if formatted == nil then
        print("Error while parsing patterns.")
        return
    end

    local template_split ---@type table<string>|nil
    if opts.generalize == true then
        template_split = patterns.generalize(formatted, extension, opts)
        if template_split == nil then
            print("Error while generalizing pattern.")
            return
        end
    else
        template_split = vim.split(formatted, "\n")
    end

    local success = patterns.insert(template_split)
    if success == false then
        print("Could not insert header.")
    end
end

M.get_names = function()
    local names = {} ---@type table<string>

    for _, templ in ipairs(M.list) do
        table.insert(names, templ.name)
    end

    return names
end

return M

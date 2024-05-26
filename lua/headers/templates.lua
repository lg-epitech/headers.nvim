--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- templates.lua
--

local path = require("plenary.path")
local s = require("plenary.scandir")

--------------------Variations
---@class Variations
----Methods
---@field scan function
---@field new function
---@field add function
---@field getString function
----Variables
---@field path table
local Variations = {}

---@param dir table
---@return Variations
function Variations:scan(dir)
    local v = {}

    v.path = dir
    setmetatable(v, Variations)

    return v
end

---@param dir table
---@return Variations
function Variations:new(dir)
    dir:mkdir()

    local v = {}

    v.path = dir
    setmetatable(v, Variations)

    return v
end

---@param extension string
---@param tText string
---@param force boolean
function Variations:add(extension, tText, force)
    local vFile = self.path:joinpath(extension)

    if vFile:exists() and not force then
        return
    end

    vFile:write(tText, "w")
end

---@param extension string
---@return string|nil
function Variations:getString(extension)
    local vFile = self.path:joinpath(extension)

    if not vFile:exists() then
        return nil
    end

    return vFile:read()
end

--------------------Template
---@class Template
----Methods
---@field scan function
---@field new function
---@field edit function
----Variables
---@field name string
---@field path table
---@field is_selected boolean
---@field variations Variations
local Template = {}

---@param directory string
---@return Template|nil
function Template:scan(directory)
    local p = path:new(directory)
    if
        not p:joinpath("variations"):is_dir()
        or not p:joinpath("template.txt"):is_file()
    then
        return nil
    end

    local t = {}
    local split = vim.split(directory, "/")
    t.name = split[#split]
    t.path = p
    t.is_selected = p:joinpath("selected"):is_file()
    t.variations = Variations:scan(p:joinpath("variations"))

    setmetatable(t, Template)
    return t
end

---@param tName string
---@param tText string
---@param tPath table
---@return Template
function Template:new(tName, tText, tPath)
    tPath:mkdir()

    local t = {}

    t.name = tName
    t.path = tPath
    t.is_selected = false
    t.variations = Variations:new(t.path:joinpath("variations"))

    local tFile = path:new(t.path:joinpath("template.txt"))
    tFile:write(tText, "w")

    setmetatable(t, Template)
    return t
end

function Template:del()
    self.path:rmdir()
end

---@param new_tText string
function Template:edit(new_tText)
    local tFile = path:new(self.path:joinpath("template.txt"))

    tFile:write(new_tText, "w")
end

--------------------TemplateList
---@class TemplateList
----Methods
---@field scan function
---@field add function
---@field del function
---@field getSelected function
----Variables
---@field list table[Template]
local TemplateList = {
    list = {},
}

---Asserts if path given isn't a directory
---@param directory string
function TemplateList:scan(directory)
    local list = s.scan_dir(directory, { depth = 1, add_dirs = true })
    assert(list ~= nil, "Given path isn't a directory.")

    for _, dir in pairs(list) do
        local p = path:new(dir)

        if p:is_dir() then
            local template = Template:scan(dir)

            if template ~= nil then
                table.insert(self.list, template)
            end
        end
    end
end

---@param tName string
---@param tText string
---@param tPath string
---@return boolean
function TemplateList:add(tName, tText, tPath)
    local p = path:new(tPath):joinpath(tName)
    if p:is_dir() then
        return false
    end

    local template = Template:new(tName, tText, p)

    if template == nil then
        return false
    end

    table.insert(self.list, template)
    return true
end

---Asserts if index is invalid
---@param idx number
function TemplateList:del(idx)
    local template = self.list[idx]

    assert(template ~= nil, "Unknown index given to delete")

    template:del()

    table.remove(self.list, idx)
end

---@return Template|nil
function TemplateList:getSelected()
    for _, t in pairs(self.list) do
        if t.is_selected then
            return t
        end
    end

    return nil
end

---Asserts if index is invalid
---@param idx number
function TemplateList:select(idx)
    local template = self.list[idx]
    assert(template ~= nil, "Unknown index given to select")

    local curr_selected = self:getSelected()
    if curr_selected ~= nil then
        curr_selected.is_selected = false
    end

    template.is_selected = true
end

return TemplateList

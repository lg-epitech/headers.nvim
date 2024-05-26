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
---@field del function
---@field getString function
----Variables
---@field path table
local Variations = {}
Variations.__index = Variations

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
    local vFile = self.path:joinpath(string.lower(extension))

    if vFile:exists() and not force then
        return
    end

    vFile:write(tText, "w")
end

function Variations:del(extension)
    local vFile = self.path:joinpath(string.lower(extension))

    if not vFile:exists() then
        return
    end

    vFile:rm()
end

---@param extension string
---@return string|nil
function Variations:getString(extension)
    local vFile = self.path:joinpath(string.lower(extension))

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
---@field getString function
----Variables
---@field name string
---@field path table
---@field is_selected boolean
---@field variations Variations
local Template = {}
Template.__index = Template -- Magic with table lookup and methods, lua dumb

---@param directory string
---@return Template|nil
function Template:scan(directory)
    local p = path:new(directory)
    if
        not p:joinpath("variations"):is_dir()
        or not p:joinpath("template.txt"):exists()
    then
        return nil
    end

    local t = {}
    local split = vim.split(directory, "/")
    t.name = split[#split]
    t.path = p
    t.is_selected = p:joinpath("selected"):exists()
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
    self.path:rm({ recursive = true })
end

---@param new_tText string
function Template:edit(new_tText)
    local tFile = path:new(self.path:joinpath("template.txt"))

    tFile:write(new_tText, "w")
end

---@param extension string
---@return string
function Template:getString(extension)
    local variation = self.variations:getString(extension)

    if variation ~= nil then
        return variation
    end

    local tFile = path:new(self.path:joinpath("template.txt"))

    return tFile:read()
end

--------------------TemplateList
---@class TemplateList
----Methods
---@field scan function
---@field add function
---@field del function
---@field select function
---@field getSelected function
----Variables
---@field list table[Template]
local TemplateList = {
    list = {},
}

---Asserts if path given isn't a directory
---@param directory string Parent template dir path
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
    local p = path:new(tPath):joinpath(tName) -- TODO: sanitize tName for path
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
    ---@type Template
    local template = self.list[idx]

    assert(template ~= nil, "Unknown index given to delete")

    template:del()

    table.remove(self.list, idx)
end

---@return number, Template|nil
function TemplateList:getSelected()
    for i, t in pairs(self.list) do
        if t.is_selected then
            return i, t
        end
    end

    return 0, nil
end

---Asserts if index is invalid
---@param idx number
function TemplateList:select(idx)
    local template = self.list[idx]

    assert(template ~= nil, "Unknown index given to select")

    local i, curr_selected = self:getSelected()
    if curr_selected ~= nil and i ~= idx then
        curr_selected.is_selected = false
    end

    template.is_selected = not template.is_selected
end

return TemplateList

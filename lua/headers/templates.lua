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
---@field isVariation function
---@field getVariationTemplate function
---@field editVariation function
----Variables
---@field path table
local Variations = {}

---@param directory string
---@return Variations
function Variations:scan(directory)
    local v = {}

    v.path = directory
    setmetatable(v, Variations)

    return v
end

--------------------Template
---@class Template
----Methods
---@field scan function
---@field new function
---@field del function
---@field editTemplate function
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
    if not p:joinpath("variations"):is_dir() then
        return nil
    end

    local t = {}
    t.name = vim.split(directory, "//")[2]
    t.path = path:new(directory)
    t.is_selected = p:joinpath("selected"):is_file()
    t.variations = Variations:scan(p:joinpath("variations"))

    setmetatable(t, Template)
    return t
end

--------------------TemplateList
---@class TemplateList
----Methods
---@field scan function
---@field add function
---@field del function
---@field find function
----Variables
---@field list table[Template]
local TemplateList = {
    list = {},
}

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

return TemplateList

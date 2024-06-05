--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- commands.lua
--

local patterns = require("headers.patterns")
local templates = require("headers.templates")
local utils = require("headers.utils")

local cmd = vim.api.nvim_create_user_command

cmd("InsertSelectedHeader", function()
    local _, template = templates:getSelected()
    if template == nil then
        print("You don't have a selected header.")
        return
    end

    local extension = utils.get_extension()
    local template_string = template:getString(extension)
    if template_string == nil then
        print("Template string not found.")
        return
    end

    local formatted = patterns.format(template_string)
    if formatted == nil then
        print("Error while parsing patterns.")
        return
    end
    local template_split = patterns.generalize(formatted, extension)
    if template_split == nil then
        print("Error while generalizing pattern.")
        return
    end

    local success = patterns.insert(template_split)
    if success == false then
        print("Could not insert header.")
    end
end, {})

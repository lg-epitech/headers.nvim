--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- commands.lua
--

local templates = require("headers.templates")
local ui = require("headers.ui")

local cmd = vim.api.nvim_create_user_command

cmd("InsertSelectedHeader", function()
    templates.insert()
end, {})

cmd("Headers", function()
    ui:toggle()
end, {})

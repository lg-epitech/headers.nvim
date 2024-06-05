--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- utils_spec.lua
--

local utils = require("headers.utils")
local test = require("plenary.busted")
local assert = require("luassert")

test.describe("Utils", function()
    -- TODO: test hash name

    test.it("Get extension", function()
        local expected
        local output

        vim.api.nvim_command(":e Makefile")
        expected = "Makefile"
        output = utils.get_extension()

        assert.are.equal(expected, output)

        vim.api.nvim_command(":e main.c")
        expected = "c"
        output = utils.get_extension()

        assert.are.equal(expected, output)
    end)
end)

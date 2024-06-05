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
    test.it("Sanitize name", function()
        local name
        local output

        name = "This\nis\na\tbad name"
        output = utils.sanitize_name(name)
        assert.are.equal("This-is-a_bad_name", output)

        name = "normal"
        output = utils.sanitize_name(name)
        assert.are.equal(name, output)

        name = "wtf     is that"
        output = utils.sanitize_name(name)
        assert.are.equal("wtf_____is_that", output)

        name = "uuh*/\\:?<>|~"
        output = utils.sanitize_name(name)
        assert.are.equal("uuh", output)
    end)

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

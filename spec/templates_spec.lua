--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- templates_test.lua
--

---@type Templates
local templates = require("headers.templates")
local test = require("plenary.busted")
local assert = require("luassert")

local directory = os.getenv("PWD").."/templates"
require("headers").setup({templates_dir = directory})

---@param command string
local function get_command_output(command)
    local pipe = io.popen(command)

    if pipe == nil then
        return nil
    end
    local output = pipe:read("*a")
    pipe:close()
    return output
end

-- setup
os.execute(string.format("mv %s %s.back", directory, directory))
os.execute(string.format("mkdir %s", directory))

test.describe("Templates:", function()
    test.before_each(function()
        os.execute(string.format("rm -rf %s/*", directory))
    end)

    test.it("add: templates", function()
        templates:add("test_ok")
        templates:add("nottin")

        local output = get_command_output(string.format("ls %s", directory))

        assert.are.equal("nottin\ntest_ok\n", output)
    end)

    test.it("add: duplicate", function()
        os.execute(string.format("mkdir %s/test", directory))
        local before = get_command_output(string.format("ls -l %s", directory))
        templates:add("test")
        local after = get_command_output(string.format("ls -l %s", directory))

        assert.are.equal(before, after)
    end)

    test.it("add: ''", function()
        templates:add("")

        local output = get_command_output(string.format("ls %s", directory))

        assert.are.equal("", output)
    end)

    test.it("delete: template", function()
        os.execute(string.format("mkdir %s/test", directory))
        templates:delete("test")

        local output = get_command_output(string.format("ls %s", directory))

        assert.are.equal("a", output)
    end)
end)

-- teardown
os.execute(string.format("rm -rf %s", directory))
os.execute(string.format("mv %s.back %s", directory, directory))

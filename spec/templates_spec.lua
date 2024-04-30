--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- templates_test.lua
--

require("headers").setup({templates_dir = "/home/laurent/projects/headers.nvim/templates"})

---@type Templates
local templates = require("headers.templates")

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

describe("Templates:", function()
    setup(function()
        os.execute("mv /home/laurent/projects/headers.nvim/templates /home/laurent/projects/headers.nvim/templates.back")
        os.execute("mkdir /home/laurent/projects/headers.nvim/templates")
    end)

    before_each(function()
        os.execute("rm -rf /home/laurent/projects/headers.nvim/templates/*")
    end)

    it("add: templates", function()
        templates:add("test_ok")
        templates:add("nottin")

        local output = get_command_output("ls /home/laurent/projects/headers.nvim/templates")

        assert.are.equal("nottin\ntest_ok\n", output)
    end)

    it("add: duplicate", function()
        os.execute("mkdir /home/laurent/projects/headers.nvim/templates/test")
        local before = get_command_output("ls /home/laurent/projects/headers.nvim/templates")
        templates:add("test")
        local after = get_command_output("ls /home/laurent/projects/headers.nvim/templates")

        assert.are.equal(before, after)
    end)

    it("add: ''", function()
        templates:add("")

        local output = get_command_output("ls /home/laurent/projects/headers.nvim/templates")

        assert.are.equal("", output)
    end)

    it("delete: template", function()
        os.execute("mkdir /home/laurent/projects/headers.nvim/templates/test")
        templates:delete("test")

        local output = get_command_output("ls /home/laurent/projects/headers.nvim/templates")

        assert.are.equal("", output)
    end)

    teardown(function()
        os.execute("rm -rf /home/laurent/projects/headers.nvim/templates")
        os.execute("mv /home/laurent/projects/headers.nvim/templates.back /home/laurent/projects/headers.nvim/templates")
    end)
end)

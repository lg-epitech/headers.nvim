--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- patterns_spec.lua
--

local patterns = require("headers.patterns")
local test = require("plenary.busted")
local assert = require("luassert")
local path = require("plenary.path")

test.describe("Testing patterns:", function()
    test.it("No inhibitors", function()
        local input =
            "this is a header\nNo particular things in mind. Just a plain and simple test\theader.\n"
        local output = patterns.format(input)

        assert.are.equal(input, output)
    end)

    test.it("EOF inhibitor", function()
        local output = patterns.format("hello this is an EOF test %")

        assert.are.equal(nil, output)
    end)

    test.it("Empty header", function()
        local output = patterns.format("")

        assert.are.equal("", output)
    end)

    test.it("Unknown inhibitor", function()
        local output = patterns.format("hello this is %K")

        assert.are.equal(nil, output)
    end)

    test.it("Single inhibitor", function()
        local output = patterns.format("%%")
        local expected = "%"

        assert.are.equal(expected, output)
    end)

    test.it("Multiple consecutive inhibitors", function()
        local output = patterns.format("%%%%%%%%%%%%%%%%%%%%")
        local expected = "%%%%%%%%%%"

        assert.are.equal(expected, output)
    end)

    test.it("Percent sign", function()
        local output = patterns.format("This is a 100%% awesome")
        local expected = "This is a 100% awesome"

        assert.are.equal(expected, output)
    end)

    test.it("filetype", function()
        local output
        local expected

        vim.api.nvim_command(":e test.lua")
        output = patterns.format("This is a {%ft} file.\n")
        expected = "This is a {lua} file.\n"
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e test.c")
        output = patterns.format("This is a {%ft} file.\n")
        expected = "This is a {c} file.\n"
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e test.py")
        output = patterns.format("This is a {%ft} file.\n")
        expected = "This is a {python} file.\n"
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e test.go")
        output = patterns.format("This is a {%ft} file.\n")
        expected = "This is a {go} file.\n"
        assert.are.equal(expected, output)
    end)

    test.it("filename", function()
        local output
        local expected

        vim.api.nvim_command(":e test.lua")
        output = patterns.format("The name of this file is: %f.")
        expected = "The name of this file is: test.lua."
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e test.c")
        output = patterns.format("The name of this file is: %f.")
        expected = "The name of this file is: test.c."
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e test.py")
        output = patterns.format("The name of this file is: %f.")
        expected = "The name of this file is: test.py."
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e test.go")
        output = patterns.format("The name of this file is: %f.")
        expected = "The name of this file is: test.go."
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e Makefile")
        output = patterns.format("The name of this file is: %f.")
        expected = "The name of this file is: Makefile."
        assert.are.equal(expected, output)
    end)

    test.it("Name", function()
        local output
        local expected

        vim.api.nvim_command(":e test.lua")
        output = patterns.format("The name of this file is: %n.")
        expected = "The name of this file is: test."
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e ok.c")
        output = patterns.format("The name of this file is: %n.")
        expected = "The name of this file is: ok."
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e xdd_this_is-fun.py")
        output = patterns.format("The name of this file is: %n.")
        expected = "The name of this file is: xdd_this_is-fun."
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e a.go")
        output = patterns.format("The name of this file is: %n.")
        expected = "The name of this file is: a."
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e Makefile")
        output = patterns.format("The name of this file is: %n.")
        expected = "The name of this file is: Makefile."
        assert.are.equal(expected, output)
    end)

    test.it("Absolute path", function()
        local output
        local expected

        vim.api.nvim_command(":e test.lua")
        output = patterns.format("The absolute path of this file is: %p\n")
        expected = string.format(
            "The absolute path of this file is: %s\n",
            vim.fn.expand("%:p")
        )
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e ok.c")
        output = patterns.format("The absolute path of this file is: %p\n")
        expected = string.format(
            "The absolute path of this file is: %s\n",
            vim.fn.expand("%:p")
        )
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e Makefile")
        output = patterns.format("The absolute path of this file is: %p\n")
        expected = string.format(
            "The absolute path of this file is: %s\n",
            vim.fn.expand("%:p")
        )
        assert.are.equal(expected, output)
    end)

    test.it("HOME Relative Path", function()
        local output
        local expected

        vim.api.nvim_command(":e init.lua")
        output = patterns.format("The path relative to HOME is: %hrp\n")
        expected = string.format(
            "The path relative to HOME is: %s\n",
            vim.fn.expand("%:p:~")
        )
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e test.lua")
        output = patterns.format("The path relative to HOME is: %hrp\n")
        expected = string.format(
            "The path relative to HOME is: %s\n",
            vim.fn.expand("%:p:~")
        )
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e lua/headers/patterns.lua")
        output = patterns.format("The path relative to HOME is: %hrp\n")
        expected = string.format(
            "The path relative to HOME is: %s\n",
            vim.fn.expand("%:p:~")
        )
        assert.are.equal(expected, output)
    end)

    test.it("CWD Relative Path", function()
        local output
        local expected

        vim.api.nvim_command(":e init.lua")
        output = patterns.format("The path relative to CWD is: %crp\n")
        expected = string.format(
            "The path relative to CWD is: %s\n",
            vim.fn.expand("%:.")
        )
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e test.lua")
        output = patterns.format("The path relative to CWD is: %crp\n")
        expected = string.format(
            "The path relative to CWD is: %s\n",
            vim.fn.expand("%:.")
        )
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e lua/headers/patterns.lua")
        output = patterns.format("The path relative to CWD is: %crp\n")
        expected = string.format(
            "The path relative to CWD is: %s\n",
            vim.fn.expand("%:.")
        )
        assert.are.equal(expected, output)
    end)

    test.it("Git Relative Path", function()
        local output
        local expected

        vim.api.nvim_command(":e init.lua")
        output = patterns.format("The path relative to git is: %grp\n")
        expected = "The path relative to git is: init.lua\n"
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e test.lua")
        output = patterns.format("The path relative to git is: %grp\n")
        expected = "The path relative to git is: test.lua\n"
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e lua/headers/patterns.lua")
        output = patterns.format("The path relative to git is: %grp\n")
        expected = "The path relative to git is: lua/headers/patterns.lua\n"
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e ../test.lua")
        output = patterns.format("The path relative to git is: %grp\n")
        expected = string.format(
            "The path relative to git is: %s\n",
            vim.fn.expand("%:p:~")
        )
        assert.are.equal(expected, output)
    end)

    test.it("Git name", function()
        local output
        local expected

        vim.api.nvim_command(":e lua/headers/patterns.lua")
        output = patterns.format("Current git repo is: %g\n")
        expected = "Current git repo is: headers.nvim\n"
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e ../test.lua")
        output = patterns.format("Current git repo is: %g\n")
        expected =
            string.format("Current git repo is: %s\n", vim.fn.expand("%:h"))
        assert.are.equal(expected, output)
    end)

    test.it("Dates", function()
        local dd = io.popen("date +%d"):read()
        local mm = io.popen("date +%m"):read()
        local yy = io.popen("date +%y"):read()
        local yyyy = io.popen("date +%Y"):read()
        local output
        local expected

        output = patterns.format("Date is beautiful: %dd/%mm/%yyyy")
        expected = string.format("Date is beautiful: %s/%s/%s", dd, mm, yyyy)
        assert.are.equal(expected, output)

        output = patterns.format("Date is beautiful: %mm:%dd:%yyyy")
        expected = string.format("Date is beautiful: %s:%s:%s", mm, dd, yyyy)
        assert.are.equal(expected, output)

        output = patterns.format("Date is beautiful: %mm:%dd:%yy")
        expected = string.format("Date is beautiful: %s:%s:%s", mm, dd, yy)
        assert.are.equal(expected, output)

        output = patterns.format("Date is beautiful: %mm:%dd")
        expected = string.format("Date is beautiful: %s:%s", mm, dd)
        assert.are.equal(expected, output)

        output = patterns.format("Date is beautiful: %dd%mm%yyyy")
        expected = string.format("Date is beautiful: %s%s%s", dd, mm, yyyy)
        assert.are.equal(expected, output)
    end)

    test.it("Session user", function()
        local user = io.popen("whoami"):read()

        local output = patterns.format("%su")
        assert.are.equal(user, output)
    end)

    test.it("File extension", function()
        local output
        local expected

        vim.api.nvim_command(":e init.lua")
        output = patterns.format("Extension lol %e")
        expected = "Extension lol lua"
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e init.ex")
        output = patterns.format("Extension lol %e")
        expected = "Extension lol ex"
        assert.are.equal(expected, output)

        vim.api.nvim_command(":e Makefile")
        output = patterns.format("Extension lol %e")
        expected = "Extension lol "
        assert.are.equal(expected, output)
    end)
end)

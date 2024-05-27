--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- templates_test.lua
--

---@type TemplateList
local templates = require("headers.templates")
local test = require("plenary.busted")
local path = require("plenary.path")
local assert = require("luassert")

local dir = path:new(os.getenv("PWD")):joinpath("/templates")
require("headers").setup({ templates_dir = dir })

-- setup
os.execute(string.format("mv %s %s.back", dir, dir))
os.execute(string.format("mkdir %s", dir))

test.describe("Templates", function()
    test.it("Init scan invalid path", function()
        local success = templates:scan("gertrude")
        assert.are.equal(false, success)

        success = templates:scan(tostring(dir:joinpath("Makefile")))
        assert.are.equal(false, success)
    end)

    test.it("Init scan without template.txt", function()
        local t = dir:joinpath("gertrude")
        t:mkdir()

        local v = t:joinpath("variations")
        v:mkdir()

        templates:scan(tostring(dir))
        assert.are.equal(0, #templates.list)

        t:rm({ recursive = true })
    end)

    test.it("Init scan without variations", function()
        local t = dir:joinpath("gertrude")
        t:mkdir()

        local tx = "gertrude is an amazing person."
        local tp = t:joinpath("template.txt")
        tp:write(tx, "w")

        templates:scan(tostring(dir))
        assert.are.equal(0, #templates.list)
    end)

    test.it("Init scan with one template", function()
        local name = "gertrude"
        local t = dir:joinpath(name)
        t:mkdir()

        local tx = "gertrude is an amazing person."
        local tp = t:joinpath("template.txt")
        tp:write(tx, "w")

        local v = t:joinpath("variations")
        v:mkdir()

        templates:scan(tostring(dir))
        assert.are.equal(1, #templates.list)
        assert.are.equal(name, templates.list[1].name)
        assert.are.equal(tostring(t), tostring(templates.list[1].path))
        assert.are.equal(false, templates.list[1].is_selected)
        assert.are.equal(
            tostring(v),
            tostring(templates.list[1].variations.path)
        )
    end)

    test.it("Template delete invalid index", function()
        local success = templates:del(12)

        assert.are.equal(false, success)
    end)

    test.it("Template delete gertrude", function()
        local tp = templates.list[1]
        local success = templates:del(1)

        assert.are.equal(true, success)
        assert.are.equal(false, tp.path:is_dir())
        assert.are.equal(0, #templates.list)
    end)

    test.it("Init scan with multiple templates", function()
        local name = "gertrude"
        local t = dir:joinpath(name)
        t:mkdir()

        local tx = "gertrude is an amazing person."
        local tp = t:joinpath("template.txt")
        tp:write(tx, "w")

        local v = t:joinpath("variations")
        v:mkdir()

        local name2 = "jeanine"
        local t2 = dir:joinpath(name2)
        t2:mkdir()

        local tx2 = "jeanine is an amazing person."
        local tp2 = t2:joinpath("template.txt")
        tp2:write(tx2, "w")

        local v2 = t2:joinpath("variations")
        v2:mkdir()

        local s2 = t2:joinpath("selected")
        s2:write("", "w")

        templates:scan(tostring(dir))
        assert.are.equal(2, #templates.list)

        assert.are.equal(name, templates.list[1].name)
        assert.are.equal(tostring(t), tostring(templates.list[1].path))
        assert.are.equal(
            tostring(v),
            tostring(templates.list[1].variations.path)
        )

        assert.are.equal(name2, templates.list[2].name)
        assert.are.equal(tostring(t2), tostring(templates.list[2].path))
        assert.are.equal(true, templates.list[2].is_selected)
        assert.are.equal(
            tostring(v2),
            tostring(templates.list[2].variations.path)
        )
    end)

    test.it("Del 2 idx", function()
        local tp2 = templates.list[2]
        templates:del(2)
        assert.are.equal(1, #templates.list)
        assert.are.equal(false, tp2.path:is_dir())

        local tp1 = templates.list[1]
        templates:del(1)
        assert.are.equal(0, #templates.list)
        assert.are.equal(false, tp1.path:is_dir())
    end)

    test.it("Add template name edge cases", function()
        local name

        name = "complete*"
        templates:add(name, "o", tostring(dir))
        assert.are.equal(1, #templates.list)
        assert.are.equal("complete", templates.list[1].name)
        templates:del(1)

        name = "o//k"
        templates:add(name, "o", tostring(dir))
        assert.are.equal(1, #templates.list)
        assert.are.equal("ok", templates.list[1].name)
        templates:del(1)

        name = "~this is \\a\ntest"
        templates:add(name, "o", tostring(dir))
        assert.are.equal(1, #templates.list)
        assert.are.equal("this_is_a-test", templates.list[1].name)
        templates:del(1)

        local success

        name = ""
        success = templates:add(name, "o", tostring(dir))
        assert.are.equal(false, success)

        name = "/~\\"
        success = templates:add(name, "o", tostring(dir))
        assert.are.equal(false, success)

        assert.are.equal(0, #templates.list)
    end)

    test.it("Add template", function()
        local name = "gertrude"
        local text = "Gertrude is otherwise known for her services :)"
        local success = templates:add(name, text, tostring(dir))

        local name2 = "this_is_a_test"
        local text2 = "testing purposes\n\n"
        local success2 = templates:add(name2, text2, tostring(dir))

        assert.are.equal(2, #templates.list)

        assert.are.equal(true, success)
        assert.are.equal(name, templates.list[1].name)
        assert.are.equal(
            tostring(dir:joinpath(name)),
            tostring(templates.list[1].path)
        )
        assert.are.equal(
            text,
            dir:joinpath(name):joinpath("template.txt"):read()
        )
        assert.are.equal(false, templates.list[1].is_selected)
        assert.are.equal(
            tostring(dir:joinpath(name):joinpath("variations")),
            tostring(templates.list[1].variations.path)
        )

        assert.are.equal(true, success2)
        assert.are.equal(name2, templates.list[2].name)
        assert.are.equal(
            tostring(dir:joinpath(name2)),
            tostring(templates.list[2].path)
        )
        assert.are.equal(
            text2,
            dir:joinpath(name2):joinpath("template.txt"):read()
        )
        assert.are.equal(false, templates.list[2].is_selected)
        assert.are.equal(
            tostring(dir:joinpath(name2):joinpath("variations")),
            tostring(templates.list[2].variations.path)
        )
    end)

    test.it("Templates invalid index selection", function()
        local success = templates:select(42)

        assert.are.equal(false, success)
    end)

    test.it("Templates selection", function()
        local _, t = templates:getSelected()

        assert.are.equal(nil, t)

        local success = templates:select(1)
        assert.are.equal(true, success)
        assert.are.equal(true, templates.list[1].is_selected)
        assert.are.equal(false, templates.list[2].is_selected)

        success = templates:select(2)
        assert.are.equal(true, success)
        assert.are.equal(false, templates.list[1].is_selected)
        assert.are.equal(true, templates.list[2].is_selected)

        success = templates:select(2)
        assert.are.equal(true, success)
        assert.are.equal(false, templates.list[1].is_selected)
        assert.are.equal(false, templates.list[2].is_selected)
    end)

    test.it("Template edit", function()
        templates:select(1)
        local _, t = templates:getSelected()

        local new_text = "Yellowwww world"
        t:edit(new_text)

        assert.are.equal(new_text, t.path:joinpath("template.txt"):read())

        new_text = "uh\nuh\nuh\nuh\nuh\nuh\nuh\nuh\nuh\nuh\n\r\n\r"
        t:edit(new_text)
        assert.are.equal(new_text, t.path:joinpath("template.txt"):read())
    end)

    test.it("Template variations", function()
        local _, t = templates:getSelected()
        local v = "THIS IS A FUCKING LUA FILE HHELL YEAH"

        t.variations:add("Lua", v, false)
        assert.are.equal(v, t.variations:getString("lua"))

        t.variations:add("Lua", "whatever", false)
        assert.are.equal(v, t.variations:getString("lua"))

        t.variations:add("Lua", "whatever", true)
        assert.are.equal("whatever", t.variations:getString("lua"))

        assert.are.equal(nil, t.variations:getString("ok"))

        t.variations:del("LUA")
        assert.are.equal(nil, t.variations:getString("lua"))

        t.variations:add("Makefile", "GNUMake lol", false)
        assert.are.equal("GNUMake lol", t.variations:getString("makefile"))
    end)

    test.it("Template getString", function()
        templates:del(1)
        templates:del(1)
        assert.are.equal(0, #templates.list)

        local name = "gertrude"
        local text = "this is a header for gertrude.\n"

        templates:add(name, text, tostring(dir))
        assert.are.equal(1, #templates.list)

        local template = templates.list[1]

        local lua_text = "this is a header for lua."
        template.variations:add("lua", lua_text, false)

        local output

        output = template:getString("Makefile")
        assert.are.equal(text, output)

        output = template:getString("Lua")
        assert.are.equal(lua_text, output)
    end)
end)

-- teardown
os.execute(string.format("rm -rf %s", dir))
os.execute(string.format("mv %s.back %s", dir, dir))

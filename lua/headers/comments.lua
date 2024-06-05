--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- comments.lua
--

local M = {}

---@class comment_type
---@field head string|nil
---@field middle string
---@field tail string|nil
local type = {}

---@param head string|nil
---@param middle string
---@param tail string|nil
function type:new(head, middle, tail)
    local new_type = {}

    new_type.head = head
    new_type.middle = middle
    new_type.tail = tail
    setmetatable(new_type, type)
    return new_type
end

---@class comment
---@field names table<string>
---@field type comment_type
local comment = {}

---@param names table<string>
---@param t comment_type
function comment:new(names, t)
    local new_comment = {}

    new_comment.names = names
    new_comment.type = type:new(t.head, t.middle, t.tail)
    setmetatable(new_comment, comment)
    return new_comment
end

-- stylua: ignore start
---@type table<comment>
local __comments = {
    comment:new({ "lua" }, { middle = "--" }),
    comment:new(
        { "c", "h", "cpp", "hpp", "js", "cs", "go", "php", "asm", "s",
        "java", "kt", "swift", "ts", "rs", "scala", "sc", "css", "zig" },
        { head = "/*", middle = "**", tail = "*/" }
    ),
    comment:new({ "py", "makefile", "rb", "r", "pl", "ex", "sh" }, { middle = "#" }),
    comment:new({ "erl", "hrl" }, { middle = "%" }),
    comment:new({ "hs", "lhs" }, { head = "{-", middle = "--", tail = "-}" }),
    comment:new({ "jsx" }, { head = "{/*", middle = "**", tail = "*/}" }),
    comment:new({ "html" }, { head = "<!--", middle = "--", tail = "-->" }),
    comment:new({ "cbl", "cob", "cpy" }, { middle = "      *" }),
    comment:new({ "clj", "cljs", "cljr", "cljc", "cljd", "edn" }, { middle = ";;" }),
    comment:new({ "lisp", "lsp", "l", "cl", "fasl" }, { middle = ";" }),
    comment:new({ "vim" }, { middle = "\"" }),
    comment:new({ "f", "f90", "for" }, { middle = "!" }),
    comment:new({ "gleam" }, { middle = "//" }),
    comment:new({ "jl" }, { head = "#=", middle = "==", tail = "=#" }),
    comment:new({ "ml" }, { head = "(*", middle = "**", tail = "*)" }),
}
-- stylua: ignore end

M.list = __comments

---@param ft string
---@return comment_type|nil
function M.find(ft)
    ft = string.lower(ft)

    for _, com in pairs(__comments) do
        for _, name in pairs(com.names) do
            if name == ft then
                return com.type
            end
        end
    end

    return nil
end

return M

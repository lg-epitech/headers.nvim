
local template = "ok mdr % ok"


local function split(input, seperator)
    if input == nil or seperator == nil then
        return nil
    end
    local t = {}
    for str in string.gmatch(input, "([^%%]+)") do
        table.insert(t, str)
    end
    return t
end

local t = split(template, "%")
print(vim.inspect(t))

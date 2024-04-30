--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- utils.lua
--

local lfs = require("lfs")

---@param name string
local function is_dir(name)
    local cd = lfs.currentdir()
    local is = lfs.chdir(name) and true or false
    lfs.chdir(cd)
    return is
end

---@param path string
local function remove_recursively(path)
    for file in lfs.dir(path) do
        local file_path = path..'/'..file
        if file ~= "." and file ~= ".." then
            if lfs.attributes(file_path, 'mode') == 'file' then
                os.remove(file_path)
            elseif lfs.attributes(file_path, 'mode') == 'directory' then
                remove_recursively(file_path)
            end
        end
    end
    lfs.rmdir(path)
end

return {
    is_dir = is_dir,
    remove_recursively = remove_recursively,
}

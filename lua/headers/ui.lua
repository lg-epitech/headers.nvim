--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- ui.lua
--

local templates = require("headers.templates")
local popup = require("plenary.popup")

-- TODO: Interface

---@class HeadersUI
---@field bufHandle? integer
---@field winnr? integer
---@field win? table
local UI = {}

function UI:setup()
    -- Auto commands
    vim.api.nvim_create_autocmd("BufLeave", {
        pattern = "Headers",
        callback = function()
            self:close()
        end,
        nested = true,
    })
end

function UI:configure()
    -- Options
    local option = vim.api.nvim_set_option_value

    vim.api.nvim_buf_set_name(self.bufHandle, "Headers")
    option("number", true, { win = self.winnr })
    option("winhl", "Normal:Headers", { win = self.winnr })
    option("filetype", "headers", { buf = self.bufHandle })
    option("buftype", "acwrite", { buf = self.bufHandle })
    option("bufhidden", "delete", { buf = self.bufHandle })

    -- User commands
    vim.api.nvim_buf_set_keymap(
        self.bufHandle,
        "n",
        "q",
        "<Cmd>lua require('headers.ui'):toggle()<CR>",
        { silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        self.bufHandle,
        "n",
        "<ESC>",
        "<Cmd>lua require('headers.ui'):toggle()<CR>",
        { silent = true }
    )
end

function UI:window()
    local borders = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local width = HConfig.width or 60
    local height = HConfig.height or 20

    self.bufHandle = vim.api.nvim_create_buf(false, false)
    self.winnr, self.win = popup.create(self.bufHandle, {
        title = "Headers.nvim",
        highlight = "Headers",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor(((vim.o.columns - width) / 2)),
        minwidth = width,
        minheight = height,
        borderchars = borders,
        number = true,
    })
end

function UI:open()
    self:window()
    self:configure()

    local names = templates.getNames()

    vim.api.nvim_buf_set_lines(self.bufHandle, 0, #names, false, names)
end

function UI:close()
    if self.win == nil then
        return
    end

    self.win = nil
    self.bufHandle = nil

    vim.api.nvim_win_close(self.winnr, true)

    self.winnr = nil

end

function UI:toggle()
    if self.win == nil or not vim.api.nvim_win_is_valid(self.winnr) then
        self:open()
    else
        self:close()
    end
end

return UI

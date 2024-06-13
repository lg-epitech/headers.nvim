--
-- EPITECH PROJECT, 2024
-- headers.nvim
-- File description:
-- ui.lua
--

local templates = require("headers.templates")
local popup = require("plenary.popup")

-- TODO: Interface

---@class headers_ui
---@field list_bufh? integer
---@field list_winnr? integer
---@field list_win? table
---@field preview_bufh? integer
---@field preview_winnr? integer
---@field preview_win? table
---@field help_bufh? integer
---@field help_winnr? integer
---@field help_win? table
local ui = {}

local list_width = 30
local list_height = 30

local preview_width = 80
local preview_height = 30

local help_width = list_width + preview_width
local help_height = 1

local padding = 2 -- This is due to popup adding 2 extra length

local borders = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

function ui:setup()
    -- Auto commands
    vim.api.nvim_create_autocmd("BufLeave", {
        pattern = "HeadersList",
        callback = function()
            self:close()
        end,
        nested = true,
    })
end

function ui:open_list_window()
    self.list_bufh = vim.api.nvim_create_buf(false, false)
    self.list_winnr, self.list_win = popup.create(self.list_bufh, {
        title = "Headers List",
        highlight = "HeadersList",
        line = math.floor(((vim.o.lines - list_height) / 2) - help_height),
        col = math.floor((vim.o.columns - (list_width + preview_width)) / 2),
        minwidth = list_width,
        minheight = list_height,
        borderchars = borders,
        number = true,
    })

    -- Options
    local option = vim.api.nvim_set_option_value

    vim.api.nvim_buf_set_name(self.list_bufh, "HeadersList")
    option("number", true, { win = self.list_winnr })
    option("filetype", "headers", { buf = self.list_bufh })
    option("buftype", "acwrite", { buf = self.list_bufh })
    option("bufhidden", "delete", { buf = self.list_bufh })

    -- User commands
    vim.api.nvim_buf_set_keymap(
        self.list_bufh,
        "n",
        "q",
        "<Cmd>lua require('headers.ui'):toggle()<CR>",
        { silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        self.list_bufh,
        "n",
        "<ESC>",
        "<Cmd>lua require('headers.ui'):toggle()<CR>",
        { silent = true }
    )
end

function ui:open_preview_window()
    self.preview_bufh = vim.api.nvim_create_buf(false, false)
    self.preview_winnr, self.preview_win = popup.create(self.preview_bufh, {
        title = "Preview",
        highlight = "HeadersPreview",
        line = math.floor(((vim.o.lines - preview_height) / 2) - help_height),
        col = math.floor((vim.o.columns - (preview_width + list_width)) / 2 + list_width + padding),
        minwidth = preview_width,
        minheight = preview_height,
        borderchars = borders,
        number = true,
    })

    -- Options
    local option = vim.api.nvim_set_option_value

    vim.api.nvim_buf_set_name(self.preview_bufh, "HeadersPreview")
    option("filetype", "headers", { buf = self.preview_bufh })
    option("buftype", "acwrite", { buf = self.preview_bufh })
    option("bufhidden", "delete", { buf = self.preview_bufh })
end

function ui:open_help_window()
    self.help_bufh = vim.api.nvim_create_buf(false, false)
    self.help_winnr, self.help_win = popup.create(self.help_bufh, {
        title = "Help",
        highlight = "HeadersHelp",
        line = math.floor((vim.o.lines - help_height) / 2 + preview_height / 2 + padding),
        col = math.floor((vim.o.columns - help_width) / 2),
        minwidth = help_width + padding,
        minheight = help_height,
        borderchars = borders,
        number = true,
    })

    -- Options
    local option = vim.api.nvim_set_option_value

    vim.api.nvim_buf_set_name(self.help_bufh, "HeadersHelp")
    option("filetype", "headers", { buf = self.help_bufh })
    option("buftype", "acwrite", { buf = self.help_bufh })
    option("bufhidden", "delete", { buf = self.help_bufh })
end

function ui:open()
    self:open_preview_window()
    self:open_help_window()
    self:open_list_window()

    local names = templates.get_names()

    vim.api.nvim_buf_set_lines(self.list_bufh, 0, #names, false, names)
end

function ui:close_list_window()
    if self.list_win == nil then
        return
    end

    self.list_win = nil
    self.list_bufh = nil

    vim.api.nvim_win_close(self.list_winnr, true)

    self.list_winnr = nil
end

function ui:close_preview_window()
    if self.preview_win == nil then
        return
    end

    self.preview_win = nil
    self.preview_bufh = nil

    vim.api.nvim_win_close(self.preview_winnr, true)

    self.preview_winnr = nil
end

function ui:close_help_window()
    if self.help_win == nil then
        return
    end

    self.help_win = nil
    self.help_bufh = nil

    vim.api.nvim_win_close(self.help_winnr, true)

    self.help_winnr = nil
end

function ui:close()
    self:close_list_window()
    self:close_preview_window()
    self:close_help_window()
end

function ui:toggle()
    if self.list_win == nil or not vim.api.nvim_win_is_valid(self.list_winnr) then
        self:open()
    else
        self:close()
    end
end

return ui

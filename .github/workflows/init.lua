local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        {
            "headers.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            dir = "/home/runner/headers.nvim/headers.nvim",

            opts = {
                templates_dir = "/home/runner/headers.nvim/headers.nvim/templates"
            }
        },
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
})

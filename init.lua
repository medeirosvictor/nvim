-- Version guard: this config requires Neovim 0.11+
if vim.fn.has("nvim-0.11") ~= 1 then
  vim.api.nvim_echo({
    { "This config requires Neovim 0.11+.\n", "ErrorMsg" },
    { "You have: " .. tostring(vim.version()) .. "\n", "WarningMsg" },
    { "Install from https://github.com/neovim/neovim/releases", "Normal" },
  }, true, {})
  return
end

require("config.options")
require("config.autocmds")

vim.defer_fn(function()
  require("config.keymaps")
end, 0)

-- Native Neovim 0.11+ commenting (replaces Comment.nvim)
-- gc{motion} / gcc toggle comment; works in normal and visual mode
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<C-/>", "gc",  { remap = true, desc = "Toggle comment" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = { lazy = false },
  install = { colorscheme = { "terafox" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "netrwPlugin" },
    },
  },
})

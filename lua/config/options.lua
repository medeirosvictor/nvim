local opt = vim.opt
local g = vim.g

opt.relativenumber = true
opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.termguicolors = true

opt.ignorecase = true
opt.smartcase = true

opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.updatetime = 50

opt.signcolumn = "yes"
opt.colorcolumn = "80"

opt.cursorline = true

opt.hlsearch = true
opt.incsearch = true

g.mapleader = " "

opt.clipboard = "unnamedplus"

-- Disable matchparen highlight (rainbow colors from treesitter are enough)
vim.g.loaded_matchparen = 1

-- Folding (managed by nvim-ufo)
opt.foldcolumn = "0"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

opt.list = false

local opt = vim.opt
local g = vim.g

opt.relativenumber = true
opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.wrap = false
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

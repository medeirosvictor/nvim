local keymap = vim.keymap

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.g.mapleader = " "

vim.wo.number = true

vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.winblend = 0

vim.opt.autoindent = true
vim.opt.hlsearch  = true
vim.opt.title = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.ai = true --Auto indent
vim.opt.si = true -- Smart indent
vim.opt.backspace = 'start,eol,indent'
vim.opt.path:append { '**' } --Finding files - search down into subfolders
vim.opt.wildignore:append { '/node_modules/*' }

keymap.set('n', '<C-a>', 'gg<S-v>G')
keymap.set('', 's<left>', '<C-w>w')
keymap.set('', 's<up>', '<C-w>k')
keymap.set('', 's<down>', '<C-w>j')
keymap.set('', 's<right>', '<C-w>l')


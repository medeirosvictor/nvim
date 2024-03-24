local keymap = vim.keymap

vim.cmd("set expandtab")

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.g.mapleader = " "

vim.wo.number = true

vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.winblend = 0

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

vim.filetype.add({
    extension = {
        templ = "templ",
    },
})

local custom_format  = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local cmd = "templ fmt " .. vim.fn.shellescape(filename)

    vim.fn.jobstart(cmd, {
        on_exit = function()
            -- Reload the buffer only if it's still the current buffer
            if vim.api.nvim_get_current_buf() == bufnr then
                vim.cmd('e!')
            end
        end,
    })
end

local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    -- other configuration options
    vim.keymap.set("n", "<leader>lf", custom_format, opts)
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*.templ" }, callback = custom_format })


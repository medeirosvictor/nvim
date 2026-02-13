local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "cro" })
  end,
})

autocmd("TermClose", {
  pattern = "*lazygit",
  callback = function()
    vim.cmd("bw!")
  end,
})

autocmd("VimEnter", {
  callback = function()
    vim.cmd("NvimTreeOpen")
  end,
})

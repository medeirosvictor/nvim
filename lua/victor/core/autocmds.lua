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

-- Note: lazygit TermClose autocmd removed — snacks.lazygit manages its own float lifecycle.

autocmd("VimEnter", {
  callback = function()
    vim.cmd("NvimTreeOpen")
  end,
})

-- Enable treesitter-based indentation (makes = work properly in visual mode)
autocmd("FileType", {
  callback = function()
    if pcall(vim.treesitter.start) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

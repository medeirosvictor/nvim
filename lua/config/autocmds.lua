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

-- Open NvimTree on startup, but not when alpha dashboard is showing
autocmd("VimEnter", {
  callback = function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    local is_dir = vim.fn.isdirectory(buf_name) == 1
    local is_file = buf_name ~= "" and not is_dir
    -- Only auto-open tree when opening a file or directory, not on bare `nvim`
    if is_file or is_dir then
      vim.cmd("NvimTreeOpen")
    end
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

-- decent-notes: only load if ~/.decent-notes.lua exists
local config_path = vim.fn.expand("~/.decent-notes.lua")
if vim.fn.filereadable(config_path) ~= 1 then
  return {}
end

local ok, user_config = pcall(dofile, config_path)
if not ok or type(user_config) ~= "table" then
  vim.notify(
    "[decent-notes] Failed to parse ~/.decent-notes.lua\n"
      .. "Ensure it returns a valid Lua table, e.g.:\n\n"
      .. '  return {\n    server = "http://your-server:5050",\n  }',
    vim.log.levels.ERROR
  )
  return {}
end

local server = user_config.server
if not server then
  vim.notify(
    "[decent-notes] No server configured in ~/.decent-notes.lua\n"
      .. "Add:\n\n"
      .. '  return {\n    server = "http://your-server:5050",\n  }',
    vim.log.levels.WARN
  )
  return {}
end

return {
  "medeirosvictor/decent-notes.nvim",
  config = function()
    require("decent-notes").setup({ server = server })
    vim.keymap.set("n", "<C-n>", "<cmd>DecentNotes<CR>", { desc = "Open Decent Notes" })
  end,
}

-- Copilot: AI code completion via ghost text
-- Starts disabled; toggle with <leader>ct
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = false, -- manual toggle; no unsolicited suggestions
        keymap = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<M-h>",
        },
      },
      panel = { enabled = false }, -- use blink.cmp instead
      filetypes = {
        markdown = true,
        yaml = true,
        ["."] = false,
      },
    })

    vim.keymap.set("n", "<leader>ct", function()
      require("copilot.suggestion").toggle_auto_trigger()
      local enabled = vim.b.copilot_suggestion_auto_trigger
      vim.notify("Copilot: " .. (enabled and "ON" or "OFF"))
    end, { desc = "Toggle Copilot" })
  end,
}

-- snacks.nvim: collection of QoL utilities
--   notifier    : replaces vim.notify with a modern notification UI
--   indent      : indent guides
--   words       : highlight all occurrences of the word under cursor
--   lazygit     : lazygit in a managed float (<leader>gg / <leader>gl)
--   bigfile     : disables heavy plugins for files >1.5 MB (e.g. generated GraphQL)
--   scroll      : disabled — conflicts with custom 5-line j/k jumps
--   statuscolumn: disabled — conflicts with nvim-ufo fold column
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy     = false,
  opts = {
    notifier     = { enabled = true, timeout = 3000 },
    indent       = { enabled = true },
    words        = { enabled = true },
    lazygit      = { enabled = true },
    bigfile      = { enabled = true },
    scroll       = { enabled = false },
    statuscolumn = { enabled = false },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end,     { desc = "Open Lazygit" })
    vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log() end, { desc = "Lazygit log" })
  end,
}

-- trouble.nvim v3: navigable diagnostics panel — replaces the quickfix/loclist workflow
return {
  "folke/trouble.nvim",
  opts = { use_diagnostic_signs = true },
  cmd  = "Trouble",
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
    { "<leader>xs", "<cmd>Trouble symbols toggle<cr>",                   desc = "Symbols (Trouble)" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                    desc = "Quickfix list" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                   desc = "Location list" },
  },
}

-- neotest-python: pytest adapter
-- neotest-vitest: Vitest adapter
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "marilari88/neotest-vitest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({ dap = { justMyCode = false }, python = "python3" }),
        require("neotest-vitest"),
      },
    })
    -- <leader>tO and <leader>tP use capital letters to avoid conflict with <leader>to (new tab)
    vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run() end,                     { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   { desc = "Run test file" })
    vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end,              { desc = "Test summary" })
    vim.keymap.set("n", "<leader>tO", function() require("neotest").output.open({ enter = true }) end, { desc = "Test output" })
    vim.keymap.set("n", "<leader>tP", function() require("neotest").output_panel.toggle() end,         { desc = "Test output panel" })
    vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, { desc = "Debug nearest test" })
  end,
}

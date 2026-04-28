return {
  "ej-shafran/compile-mode.nvim",
  version = "^5.0.0",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    vim.g.compile_mode = {
      default_command = {
        cpp = "c++ -std=c++23 -Wall -o %:r % && ./%:r",
        go  = "go build ./... && go run .",
      },
      auto_jump_to_first_error = true,
      auto_scroll = true,
      ask_about_save = false,
    }

    vim.keymap.set("n", "<leader>cc", "<cmd>Compile<CR>",    { desc = "Compile" })
    vim.keymap.set("n", "<leader>cr", "<cmd>Recompile<CR>",  { desc = "Recompile" })
    vim.keymap.set("n", "<leader>ce", "<cmd>NextError<CR>",  { desc = "Next compile error" })
    vim.keymap.set("n", "<leader>cE", "<cmd>PrevError<CR>",  { desc = "Prev compile error" })
  end,
}

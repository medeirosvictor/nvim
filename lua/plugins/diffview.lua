return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
  config = function()
    require("diffview").setup()
    vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>",          { desc = "Diff view open" })
    vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<CR>",         { desc = "Diff view close" })
    vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", { desc = "File git history" })
  end,
}

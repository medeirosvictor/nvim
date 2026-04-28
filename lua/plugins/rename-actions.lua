-- inc-rename: live-preview rename — type and see all changes highlighted before confirming
return {
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Rename symbol (live preview)" })
    end,
  },

  -- actions-preview: shows a diff preview of what each code action will do before applying
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      require("actions-preview").setup({
        telescope = { sorting_strategy = "ascending" },
      })
      vim.keymap.set({ "v", "n" }, "<leader>ca",
        require("actions-preview").code_actions,
        { desc = "Code action (preview)" })
    end,
  },
}

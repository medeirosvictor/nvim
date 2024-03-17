return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<C-b>", ":Neotree focus left<CR>"},
    { "<leader>bf", ":Neotree toggle left<CR>"},
    update_focused_file = { enable = true, update_root = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          -- '.git',
          -- '.DS_Store',
          -- 'thumbs.db',
        },
        never_show = {},
      },
    },
  },
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
}

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      disable_netrw = true,
      hijack_netrw = true,
      sync_root_with_cwd = true,
      update_focused_file = { enable = true, update_cwd = false },
      filesystem_watchers = {
        ignore_dirs = { ".claude" },
      },
      filters = { custom = { "^.git$" } },
      git = { enable = true, ignore = true },
      view = { width = 30, side = "left", signcolumn = "yes" },
      renderer = {
        indent_width = 2,
        symlink_destination = false,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "󰈔",
            symlink = "󰌋",
            folder = {
              default = "󰉋",
              open = "󰷏",
              empty = "󰉊",
              empty_open = "󰷏",
              symlink = "󰌋",
              symlink_open = "󰷏",
            },
            git = {
              unstaged = "󰄑",
              staged = "󰄲",
              untracked = "󰊠",
              renamed = "󰁕",
              deleted = "󰀍",
              ignored = "◌",
            },
          },
        },
      },
    })
  end,
}

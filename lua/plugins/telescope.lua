return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local actions = require("telescope.actions")
    local trouble_sources = require("trouble.sources.telescope")

    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          "node_modules", "dist", "build", ".venv",
          "%.lock$", "lock%.json$",
          "%.git/",
          "__pycache__", "%.pyc$",
          "%.class$", "%.jar$",
          "coverage/", "%.cache",
        },
        layout_strategy = "horizontal",
        layout_config = {
          width = 0.90,
          height = 0.85,
          preview_width = 0.55,
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-q>"] = trouble_sources.open,
          },
          n = {
            ["<C-q>"] = trouble_sources.open,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = true,
          no_ignore_parent = true,
          path_display = { "truncate" },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--no-ignore", "--no-ignore-parent", "--fixed-strings" }
          end,
        },
      },
    })
  end,
}

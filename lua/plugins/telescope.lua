return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local actions = require("telescope.actions")
    local trouble_sources = require("trouble.sources.telescope")

    require("telescope").setup({
      defaults = {
        -- fd respects .gitignore natively, so node_modules etc. are never scanned.
        -- file_ignore_patterns is a last-resort lua filter for anything not gitignored.
        file_ignore_patterns = {
          "%.git/",
          "%.cache",
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
          -- fd uses .gitignore by default — no_ignore removed intentionally
          find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix" },
          path_display = { "truncate" },
        },
        live_grep = {
          -- rg uses .gitignore by default — --no-ignore removed intentionally
          additional_args = function()
            return { "--hidden", "--fixed-strings" }
          end,
        },
      },
    })

    require("telescope").load_extension("fzf")
  end,
}

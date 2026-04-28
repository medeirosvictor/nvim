return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = { "node_modules", "dist", "build", ".venv" },
        mappings = { i = { ["<esc>"] = require("telescope.actions").close } },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          hidden = true,
          no_ignore = true,
          no_ignore_parent = true,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--no-ignore", "--no-ignore-parent" }
          end,
        },
      },
    })
  end,
}

return {
  { "rebelot/kanagawa.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "ellisonleao/gruvbox.nvim" },
  { "loctvl842/monokai-pro.nvim" },
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {
          {
            name = "Kanagawa Wave",
            colorscheme = "kanagawa-wave",
            before = [[
              require("kanagawa").setup({
                compile = false,
                undercurl = true,
                commentStyle = { italic = true },
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                transparent = false,
                dimInactive = false,
                terminalColors = true,
                theme = "wave",
              })
            ]],
          },
          {
            name = "Kanagawa Lotus",
            colorscheme = "kanagawa",
            before = [[
              require("kanagawa").setup({
                compile = false,
                undercurl = true,
                commentStyle = { italic = true },
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                transparent = false,
                dimInactive = false,
                terminalColors = true,
                theme = "lotus",
              })
            ]],
          },
          {
            name = "Nightfox Tera",
            colorscheme = "terafox",
          },
          {
            name = "Nightfox Nord",
            colorscheme = "nordfox",
          },
          {
            name = "Nightfox Dayfox",
            colorscheme = "dayfox",
          },
          {
            name = "Catppuccin Mocha",
            colorscheme = "catppuccin",
            before = [[
              require("catppuccin").setup()
              vim.opt.background = "dark"
            ]],
          },
          {
            name = "Catppuccin Latte",
            colorscheme = "catppuccin",
            before = [[
              require("catppuccin").setup()
              vim.opt.background = "light"
            ]],
          },
          {
            name = "Gruvbox Dark",
            colorscheme = "gruvbox",
            before = [[
              require("gruvbox").setup({
                contrast = "hard",
                italic = { strings = false, operators = false },
              })
              vim.opt.background = "dark"
            ]],
          },
          {
            name = "Gruvbox Light",
            colorscheme = "gruvbox",
            before = [[
              require("gruvbox").setup({
                contrast = "hard",
                italic = { strings = false, operators = false },
              })
              vim.opt.background = "light"
            ]],
          },
          {
            name = "Monokai Pro Spectrum",
            colorscheme = "monokai-pro",
            before = [[ require("monokai-pro").setup({ filter = "spectrum" }) ]],
          },
          {
            name = "Monokai Pro Classic",
            colorscheme = "monokai-pro",
            before = [[ require("monokai-pro").setup({ filter = "classic" }) ]],
          },
          {
            name = "Monokai Pro Octagon",
            colorscheme = "monokai-pro",
            before = [[ require("monokai-pro").setup({ filter = "octagon" }) ]],
          },
        },
        livePreview = true,
      })

      -- Default theme on startup (Themery remembers your pick after first manual switch)
      require("monokai-pro").setup({ filter = "spectrum" })
      vim.cmd("colorscheme monokai-pro")

      vim.keymap.set("n", "<leader>ct", ":Themery<CR>", { desc = "Switch theme" })
    end,
  },
}

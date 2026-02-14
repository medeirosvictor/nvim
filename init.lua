require("victor.core.options")

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/akinsho/toggleterm.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/hrsh7th/cmp-cmdline",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/saadparwaiz1/cmp_luasnip",
  "https://github.com/ThePrimeagen/harpoon",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/mg979/vim-visual-multi",
  "https://github.com/ellisonleao/gruvbox.nvim",
})

vim.defer_fn(function()
  require("victor.plugins")
  require("victor.core.keymaps")
  require("victor.core.autocmds")
  require("victor.languages.lsp")
  require("victor.languages.treesitter")
end, 0)

-- Mason: install / update LSP servers, formatters, linters inside Neovim
return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        -- run :Mason to install these (automatic_installation = false keeps it opt-in)
        ensure_installed = { "vtsls", "gopls", "rust_analyzer", "svelte" },
        automatic_installation = false,
      })
    end,
  },
}

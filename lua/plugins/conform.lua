-- ruff_format replaces black — matches [tool.ruff] in both Python repos
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        svelte     = { "prettier" },
        html       = { "prettier" },
        css        = { "prettier" },
        json       = { "prettier" },
        go         = { "gofmt" },
        rust       = { "rustfmt" },
        python     = { "ruff_format" },
        lua        = { "stylua" },
      },
      formatters = {
        prettier = {
          command = function()
            local local_bin = vim.fn.findfile("node_modules/.bin/prettier", vim.fn.getcwd() .. ";")
            return local_bin ~= "" and local_bin or "prettier"
          end,
        },
      },
      format_on_save = {
        timeout_ms   = 500,
        lsp_fallback = true,
      },
    })
  end,
}

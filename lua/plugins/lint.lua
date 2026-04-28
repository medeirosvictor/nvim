-- ruff: replaces flake8+pylint
-- eslint_d: daemon-mode eslint
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost", "InsertLeave" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      python     = { "ruff" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      svelte     = { "eslint_d" },
    }
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function() lint.try_lint() end,
    })
  end,
}

return {
  "medeirosvictor/v99",
  dependencies = { "ThePrimeagen/99" },
  config = function()
    local v99 = require("v99")

    v99.setup({
      -- provider = require("v99.providers.pi"),       -- pi with configured default
      -- provider = require("v99.providers.opencode"),  -- opencode with configured default
      -- provider = require("v99.providers.claude"),    -- claude (needs Max/API key)
      -- Switch at runtime with <leader>9c
      completion = {
        source = "native",
      },
    })

    vim.keymap.set("v", "<leader>9v", function() v99.api.visual() end)
    vim.keymap.set("n", "<leader>9x", function() v99.api.stop_all_requests() end)
    vim.keymap.set("n", "<leader>9s", function() v99.api.search() end)
    vim.keymap.set("n", "<leader>9c", function()
      require("99.extensions.telescope").select_provider()
    end, { desc = "Switch AI provider" })
  end,
}

-- vtsls: replaces ts_ls — uses the official VS Code TS extension under the hood,
--        significantly faster on large TS codebases.
return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    local servers = { "vtsls", "gopls", "clangd", "rust_analyzer", "svelte" }
    for _, server in ipairs(servers) do
      vim.lsp.config(server, { capabilities = capabilities })
      vim.lsp.enable(server)
    end

    vim.diagnostic.config({
      virtual_text = false,  -- disable inline text; use <leader>de or Trouble to see details
      signs        = true,
      underline    = true,
      float        = { border = "rounded" },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local buf = args.buf
        vim.keymap.set("n", "gd", vim.lsp.buf.definition,     { buffer = buf, desc = "Go to definition" })
        vim.keymap.set("n", "K",  vim.lsp.buf.hover,          { buffer = buf, desc = "Hover" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references,     { buffer = buf, desc = "Go to references" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration,    { buffer = buf, desc = "Go to declaration" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buf, desc = "Go to implementation" })
        -- <leader>rn → inc-rename.nvim (global keymap, live preview)
        -- <leader>ca → actions-preview.nvim (global keymap, shows diff before apply)
      end,
    })
  end,
}

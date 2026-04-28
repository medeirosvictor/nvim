-- blink.cmp: Rust-powered completion — replaces nvim-cmp + all its source plugins.
-- Sources: LSP, path, LuaSnip snippets, buffer words. Cmdline completion built-in.
return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = { "L3MON4D3/LuaSnip" },
  opts = {
    keymap = {
      preset = "default",
      ["<Tab>"] = { "accept", "fallback" },
    },
    appearance = { nerd_font_variant = "mono" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    snippets  = { preset = "luasnip" },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      accept        = { auto_brackets = { enabled = true } },
    },
  },
}

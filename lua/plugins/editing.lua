return {
  { "mg979/vim-visual-multi" },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        fast_wrap = { map = "<M-e>" },
      })
      -- Note: no nvim-cmp integration needed — blink.cmp handles bracket auto-closing natively
    end,
  },

  -- nvim-surround: wrap motions/selections with quotes, brackets, tags, etc.
  --   ys{motion}{char}  add surround  (e.g. ysiw"  wraps word with "")
  --   ds{char}          delete surround
  --   cs{old}{new}      change surround
  --   S{char}           surround in visual mode
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
}

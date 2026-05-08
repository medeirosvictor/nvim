return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    -- Add nvim-treesitter's runtime dir to rtp so highlight queries are found
    local ts_runtime = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime"
    if vim.uv.fs_stat(ts_runtime) then
      vim.opt.rtp:append(ts_runtime)
    end

    require("nvim-treesitter").setup({
      ensure_installed = {
        "lua", "vim", "vimdoc",
        "javascript", "typescript", "tsx", "graphql",
        "python", "go", "rust",
        "html", "css", "json", "svelte",
      },
      auto_install = true,
      indent = { enable = true },
    })

    -- textobjects (v1.0 API): configured via nvim-treesitter-textobjects directly
    require("nvim-treesitter-textobjects").setup({
      select = {
        enable    = true,
        lookahead = true,
        keymaps   = {
          ["af"] = "@function.outer", ["if"] = "@function.inner",
          ["ac"] = "@class.outer",    ["ic"] = "@class.inner",
          ["aa"] = "@parameter.outer", ["ia"] = "@parameter.inner",
        },
      },
      move = {
        enable    = true,
        set_jumps = true,
        goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
      },
    })
  end,
}

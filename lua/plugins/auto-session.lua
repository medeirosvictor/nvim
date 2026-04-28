return {
  "rmagatti/auto-session",
  lazy = false,
  config = function()
    require("auto-session").setup({
      auto_save       = true,
      auto_restore    = true,
      suppressed_dirs = { "~/", "~/Downloads" },
    })
  end,
}

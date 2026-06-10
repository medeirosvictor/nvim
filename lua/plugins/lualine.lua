return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = { theme = "auto", component_separators = "|", section_separators = "", globalstatus = true },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diagnostics" },
        lualine_c = { { "filename", path = 1, shorting_target = 40, symbols = { modified = " ●" } } },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}

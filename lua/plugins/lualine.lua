return {
	"nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
      require("lualine").setup({
          options = {
	    theme = "kanagawa",
	  },
      sections = {lualine_c = {require('auto-session.lib').current_session_name}}
    })
  end,
}

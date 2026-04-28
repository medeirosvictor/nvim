-- alpha-nvim: startup dashboard
return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                                    ]],
      [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
      [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
      [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
      [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
      [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
      [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      [[                                                    ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find file",       ":Telescope find_files<CR>"),
      dashboard.button("g", "󰊄  Live grep",        ":Telescope live_grep<CR>"),
      dashboard.button("r", "  Recent files",     ":Telescope oldfiles<CR>"),
      dashboard.button("s", "  Restore session",  ":SessionRestore<CR>"),
      dashboard.button("h", "󰛢  Harpoon",          ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>"),
      dashboard.button("m", "  Mason",            ":Mason<CR>"),
      dashboard.button("l", "󰒲  Lazy",             ":Lazy<CR>"),
      dashboard.button("q", "  Quit",             ":qa<CR>"),
    }

    dashboard.section.footer.val = "Neovim"

    alpha.setup(dashboard.opts)

    -- Don't open NvimTree on dashboard
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function()
        vim.cmd("NvimTreeClose")
      end,
    })
  end,
}

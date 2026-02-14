local plugins = {
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/akinsho/toggleterm.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/hrsh7th/cmp-cmdline",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/saadparwaiz1/cmp_luasnip",
  "https://github.com/ThePrimeagen/harpoon",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/mg979/vim-visual-multi",
  "https://github.com/ellisonleao/gruvbox.nvim",
}

require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,
  auto_close = true,
  update_focused_file = { enable = true, update_cwd = false },
  filters = { custom = { "^.git$" } },
  git = { enable = true, ignore = true },
  view = {
    width = 30,
    side = "left",
    signcolumn = "yes",
  },
  renderer = {
    indent_width = 2,
    icons = {
      web_devicons = {
        file = { enable = true, color = true },
      },
    },
  },
})

require("telescope").setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git", "dist", "build" },
    mappings = {
      i = {
        ["<esc>"] = require("telescope.actions").close,
      },
    },
  },
  pickers = {
    find_files = {
      theme = "dropdown",
    },
  },
})

require("lualine").setup({
  options = {
    theme = "gruvbox",
    component_separators = "|",
    section_separators = "",
    globalstatus = true,
  },
})

require("toggleterm").setup({
  size = 20,
  open_mapping = [[<c-t>]],
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = "1",
  start_in_insert = true,
  persist_size = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = { border = "curved" },
})

require("gitsigns").setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { _show_top = false, text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = { interval = 1000, follow_files = true },
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = { virt_text = true, virt_text_pos = "eol", delay = 1000 },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  max_file_length = 40000,
  preview_config = { border = "single", style = "minimal", relative = "cursor", row = 1, col = 1 },
  on_attach = function(buffer)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
    end

    map("n", "]h", gs.next_hunk, "Next Hunk")
    map("n", "[h", gs.prev_hunk, "Prev Hunk")
    map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
    map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
    map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
    map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
    map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
    map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
    map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
    map("n", "<leader>ghd", gs.diffthis, "Diff This")
    map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
  end,
})

require("which-key").setup({
  window = {
    border = "single",
  },
})

vim.cmd("colorscheme gruvbox")

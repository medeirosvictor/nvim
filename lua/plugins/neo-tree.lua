return {
	"nvim-neo-tree/neo-tree.nvim",
	keys = {
      { "<C-b>", ":Neotree focus left<CR>"},
      { "<leader>bf", ":Neotree toggle left<CR>"},
    update_focused_file = { enable = true, update_root = true },
  },
  branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
}

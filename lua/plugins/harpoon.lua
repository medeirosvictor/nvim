return {
	"ThePrimeagen/harpoon",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
        -- vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
        vim.cmd("highlight! HarpoonActive guibg=NONE guifg=#E0B0FF")
        vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#E0B0FF")
        -- vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7")
        -- vim.cmd("highlight! TabLineFill guibg=NONE guifg=white")
        require("harpoon").setup({
            tabline = true,
        })
    end,
	keys = {
		{ "<C-H>", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Mark file with harpoon" },
		{ "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = "Go to next harpoon mark" },
		{ "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = "Go to previous harpoon mark" },
		{ "<C-E>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Show harpoon marks" },
        { "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "harpoon to file 1", },
        { "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "harpoon to file 2", },
        { "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "harpoon to file 3", },
        { "<leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "harpoon to file 4", },
        { "<leader>5", "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", desc = "harpoon to file 5", },
	},
}

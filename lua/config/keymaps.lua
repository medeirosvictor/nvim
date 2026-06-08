local keymap = vim.keymap.set

-- <C-f> is now handled by grug-far (see plugins/grug-far.lua)
-- <C-S-f> opens Telescope live_grep (press <C-q> inside to send results to Trouble grouped by file)
keymap("n", "<C-S-f>", function() require('telescope.builtin').live_grep({ cwd = vim.fn.getcwd(-1, -1) }) end, { noremap = true, silent = true, desc = "Telescope live grep" })
keymap("n", "<C-p>", function() require('telescope.builtin').find_files({ cwd = vim.fn.getcwd(-1, -1) }) end, { noremap = true, silent = true, desc = "Find files" })
keymap("n", "<C-t>", ":ToggleTerm direction=float<CR>", { noremap = true, silent = true, desc = "Toggle terminal" })

keymap("n", "<leader>h", ":nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear search highlight" })

keymap("n", "<leader>ff", function() require('telescope.builtin').find_files({ cwd = vim.fn.getcwd(-1, -1) }) end, { noremap = true, silent = true, desc = "Find files" })
keymap("n", "<leader>fg", function() require('telescope.builtin').live_grep({ cwd = vim.fn.getcwd(-1, -1) }) end, { noremap = true, silent = true, desc = "Find text in files" })
keymap("n", "<leader>fb", ":lua require('telescope.builtin').buffers()<CR>", { noremap = true, silent = true, desc = "Find buffers" })
keymap("n", "<leader>fh", ":lua require('telescope.builtin').help_tags()<CR>", { noremap = true, silent = true, desc = "Find help tags" })

keymap("n", "<leader>th", ":Telescope colorscheme<CR>", { noremap = true, silent = true, desc = "Pick theme" })

keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Move to window down" })
keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Move to window up" })
keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Move to window left" })
keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Move to window right" })

keymap("n", "<leader>sv", ":vsplit<CR>", { noremap = true, silent = true, desc = "Split vertically" })
keymap("n", "<leader>sh", ":split<CR>", { noremap = true, silent = true, desc = "Split horizontally" })

keymap("n", "<leader>to", ":tabnew<CR>", { noremap = true, silent = true, desc = "New tab" })
keymap("n", "<leader>tx", ":tabclose<CR>", { noremap = true, silent = true, desc = "Close tab" })
keymap("n", "<leader>tn", ":tabnext<CR>", { noremap = true, silent = true, desc = "Next tab" })
keymap("n", "<leader>tp", ":tabprevious<CR>", { noremap = true, silent = true, desc = "Previous tab" })

keymap("n", "<leader>e", function() require('telescope.builtin').find_files({ cwd = vim.fn.getcwd(-1, -1) }) end, { noremap = true, silent = true, desc = "Find files" })

local harpoon = require("harpoon")
keymap("n", "<leader>a", function() harpoon:list():add() end, { noremap = true, silent = true, desc = "Add file to harpoon" })
keymap("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { noremap = true, silent = true, desc = "Harpoon menu" })
keymap("n", "<leader>h1", function() harpoon:list():select(1) end, { noremap = true, silent = true, desc = "Harpoon 1" })
keymap("n", "<leader>h2", function() harpoon:list():select(2) end, { noremap = true, silent = true, desc = "Harpoon 2" })
keymap("n", "<leader>h3", function() harpoon:list():select(3) end, { noremap = true, silent = true, desc = "Harpoon 3" })
keymap("n", "<leader>h4", function() harpoon:list():select(4) end, { noremap = true, silent = true, desc = "Harpoon 4" })
keymap("n", "<leader>h5", function() harpoon:list():select(5) end, { noremap = true, silent = true, desc = "Harpoon 5" })
keymap("n", "<leader>h6", function() harpoon:list():select(6) end, { noremap = true, silent = true, desc = "Harpoon 6" })
keymap("n", "<leader>h7", function() harpoon:list():select(7) end, { noremap = true, silent = true, desc = "Harpoon 7" })
keymap("n", "<leader>h8", function() harpoon:list():select(8) end, { noremap = true, silent = true, desc = "Harpoon 8" })
keymap("n", "<leader>h9", function() harpoon:list():select(9) end, { noremap = true, silent = true, desc = "Harpoon 9" })

keymap("x", "<leader>r", '"zy:%s/\\V<C-r>z//g<left><left>', { noremap = true, silent = false, desc = "Replace all in buffer (visual selection)" })

-- File operations
keymap("n", "<leader>q", "<cmd>bd<CR>", { noremap = true, silent = true, desc = "Close current buffer" })
keymap("n", "<leader>fd", ":call delete(expand('%')) | bd<CR>", { noremap = true, silent = true, desc = "Delete current file" })

-- Diagnostics
keymap("n", "<leader>de", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show full diagnostic" })

-- Folding (nvim-ufo)
keymap("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
keymap("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })

-- Visual indent/dedent (stay in visual mode)
keymap("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent (visual)" })
keymap("v", "<", "<gv", { noremap = true, silent = true, desc = "Dedent (visual)" })

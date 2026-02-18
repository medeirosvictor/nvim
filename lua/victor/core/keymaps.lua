local keymap = vim.keymap.set

keymap("n", "<C-f>", ":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", { noremap = true, silent = true, desc = "Find text in buffer" })
keymap("n", "<C-F>", ":lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true, desc = "Find text in files" })
keymap("n", "<C-p>", ":lua require('telescope.builtin').find_files()<CR>", { noremap = true, silent = true, desc = "Find files" })
keymap("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle sidebar" })
keymap("n", "<C-t>", ":ToggleTerm direction=float<CR>", { noremap = true, silent = true, desc = "Toggle terminal" })

keymap("n", "<leader>h", ":nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear search highlight" })

-- j/k jump 5 lines (arrow keys stay single line)
keymap("n", "j", "5j", { noremap = true, silent = true, desc = "Jump 5 lines down" })
keymap("n", "k", "5k", { noremap = true, silent = true, desc = "Jump 5 lines up" })
keymap("v", "j", "5j", { noremap = true, silent = true, desc = "Jump 5 lines down" })
keymap("v", "k", "5k", { noremap = true, silent = true, desc = "Jump 5 lines up" })

keymap("n", "<leader>ff", ":lua require('telescope.builtin').find_files()<CR>", { noremap = true, silent = true, desc = "Find files" })
keymap("n", "<leader>fg", ":lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true, desc = "Find text in files" })
keymap("n", "<leader>fG", ":lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true, desc = "Find text in files" })
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

keymap("n", "<leader>e", ":NvimTreeFocus<CR>", { noremap = true, silent = true, desc = "Focus file tree" })

local harpoon = require("harpoon")
keymap("n", "<leader>a", function() harpoon:list():add() end, { noremap = true, silent = true, desc = "Add file to harpoon" })
keymap("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { noremap = true, silent = true, desc = "Harpoon menu" })
keymap("n", "<leader>h1", function() harpoon:list():select(1) end, { noremap = true, silent = true, desc = "Harpoon 1" })
keymap("n", "<leader>h2", function() harpoon:list():select(2) end, { noremap = true, silent = true, desc = "Harpoon 2" })
keymap("n", "<leader>h3", function() harpoon:list():select(3) end, { noremap = true, silent = true, desc = "Harpoon 3" })
keymap("n", "<leader>h4", function() harpoon:list():select(4) end, { noremap = true, silent = true, desc = "Harpoon 4" })

keymap("x", "<leader>r", '"zy:%s/\\V<C-r>z//g<left><left>', { noremap = true, silent = false, desc = "Replace all in buffer (visual selection)" })

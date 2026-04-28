-- bufferline: tab bar showing open buffers; harpoon marks shown as pinned tabs
return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("bufferline").setup({
      options = {
        mode              = "buffers",
        diagnostics       = "nvim_lsp",
        separator_style   = "slant",
        modified_icon     = "●",
        show_close_icon   = false,
        show_buffer_close_icons = true,
        offsets = {
          { filetype = "NvimTree", text = "EXPLORER", highlight = "Directory", separator = true },
        },
      },
    })
    vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer tab" })
    vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer tab" })
    vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin/unpin buffer" })
    vim.keymap.set("n", "<leader>bx", "<cmd>BufferLinePickClose<CR>", { desc = "Pick buffer to close" })
    vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close current buffer" })
    vim.keymap.set("n", "<leader>ba", "<cmd>%bd|e#|bd#|NvimTreeOpen<CR>", { desc = "Close all buffers" })
    vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
  end,
}

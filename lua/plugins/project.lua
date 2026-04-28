-- project.nvim: project switcher — detects projects by .git / pyproject.toml / package.json etc.
-- <leader>fp: save session → pick project → cd → close buffers → restore session → open tree
return {
  "ahmedkhalf/project.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("project_nvim").setup({
      detection_methods = { "pattern", "lsp" },
      patterns = { ".git", "pyproject.toml", "package.json", "go.mod", "Cargo.toml" },
      show_hidden = false,
      silent_chdir = true,
    })
    require("telescope").load_extension("projects")

    -- After project.nvim cds into the new project:
    -- close all buffers, restore that project's session, open the tree
    vim.api.nvim_create_autocmd("User", {
      pattern = "ProjectChanged",
      callback = function()
        vim.cmd("%bd")
        vim.cmd("SessionRestore")
        vim.cmd("NvimTreeOpen")
      end,
    })

    -- Save current session BEFORE opening the picker, then show it
    vim.keymap.set("n", "<leader>fp", function()
      vim.cmd("SessionSave")
      vim.cmd("Telescope projects")
    end, { desc = "Switch project" })
  end,
}

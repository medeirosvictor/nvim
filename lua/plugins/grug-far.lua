return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    {
      "<C-f>",
      function() require("grug-far").open({ transient = true }) end,
      desc = "Search & replace (grug-far)",
    },
    {
      "<C-f>",
      function()
        vim.cmd('noau normal! "zy')
        require("grug-far").open({
          transient = true,
          prefills = { search = vim.fn.getreg("z") },
        })
      end,
      mode = "v",
      desc = "Search selection (grug-far)",
    },
  },
  opts = {
    headerMaxWidth = 80,
    windowCreationCommand = "tabnew",
  },
}

-- nvim-dap-python uses debugpy — supports remote attach for Django in Docker/Okteto.
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "mfussenegger/nvim-dap-python",
  },
  config = function()
    local dap   = require("dap")
    local dapui = require("dapui")

    require("nvim-dap-virtual-text").setup({ commented = true })
    dapui.setup()
    require("dap-python").setup("python3")

    dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint,                                           { desc = "Toggle breakpoint" })
    vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, { desc = "Conditional breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue,                                                   { desc = "DAP continue" })
    vim.keymap.set("n", "<leader>do", dap.step_over,                                                   { desc = "Step over" })
    vim.keymap.set("n", "<leader>di", dap.step_into,                                                   { desc = "Step into" })
    vim.keymap.set("n", "<leader>dO", dap.step_out,                                                    { desc = "Step out" })
    vim.keymap.set("n", "<leader>du", dapui.toggle,                                                    { desc = "Toggle DAP UI" })
    vim.keymap.set("n", "<leader>dr", dap.repl.open,                                                   { desc = "DAP REPL" })
  end,
}

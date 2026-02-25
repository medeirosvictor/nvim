local M = {}

M.check = function()
  vim.health.start("victor.health")

  -- Neovim version
  if vim.fn.has("nvim-0.11") == 1 then
    vim.health.ok("Neovim 0.11+ (" .. tostring(vim.version()) .. ")")
  else
    vim.health.error("Neovim 0.11+ required, found " .. tostring(vim.version()), {
      "Install from https://github.com/neovim/neovim/releases",
    })
  end

  -- Required
  local required = {
    { cmd = "git", reason = "plugin management (lazy.nvim)" },
  }
  for _, dep in ipairs(required) do
    if vim.fn.executable(dep.cmd) == 1 then
      vim.health.ok(dep.cmd .. " found")
    else
      vim.health.error(dep.cmd .. " not found — required for " .. dep.reason)
    end
  end

  -- Optional: C compiler for treesitter
  local has_cc = vim.fn.executable("cc") == 1
    or vim.fn.executable("gcc") == 1
    or vim.fn.executable("clang") == 1
  if has_cc then
    vim.health.ok("C compiler found (needed for treesitter)")
  else
    vim.health.warn("No C compiler found (cc/gcc/clang) — treesitter parsers won't compile", {
      "Install build-essential (Debian/Ubuntu) or base-devel (Arch)",
    })
  end

  -- Optional: language servers / runtimes
  local optional = {
    { cmd = "node",           reason = "ts_ls, pyright, eslint LSPs" },
    { cmd = "npm",            reason = "installing LSP servers via npm" },
    { cmd = "python3",        reason = "pyright LSP" },
    { cmd = "go",             reason = "gopls LSP" },
    { cmd = "cargo",          reason = "rust-analyzer LSP" },
    { cmd = "ripgrep",        alt = "rg", reason = "telescope live_grep" },
    { cmd = "fd",             alt = "fdfind", reason = "telescope find_files (faster)" },
  }
  for _, dep in ipairs(optional) do
    local found = vim.fn.executable(dep.cmd) == 1
    if not found and dep.alt then
      found = vim.fn.executable(dep.alt) == 1
    end
    if found then
      vim.health.ok(dep.cmd .. " found")
    else
      vim.health.warn(dep.cmd .. " not found — needed for " .. dep.reason)
    end
  end
end

return M

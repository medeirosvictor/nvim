-- Version guard: this config requires Neovim 0.11+
if vim.fn.has("nvim-0.11") ~= 1 then
  vim.api.nvim_echo({
    { "This config requires Neovim 0.11+.\n", "ErrorMsg" },
    { "You have: " .. tostring(vim.version()) .. "\n", "WarningMsg" },
    { "Install from https://github.com/neovim/neovim/releases", "Normal" },
  }, true, {})
  return
end

require("victor.core.options")
require("victor.core.autocmds")

vim.defer_fn(function()
  require("victor.core.keymaps")
end, 0)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- decent-notes: only load if ~/.decent-notes.lua exists
local decent_notes_spec = (function()
  local config_path = vim.fn.expand("~/.decent-notes.lua")
  if vim.fn.filereadable(config_path) ~= 1 then
    return nil
  end

  local ok, user_config = pcall(dofile, config_path)
  if not ok or type(user_config) ~= "table" then
    vim.notify(
      "[decent-notes] Failed to parse ~/.decent-notes.lua\n"
        .. "Ensure it returns a valid Lua table, e.g.:\n\n"
        .. '  return {\n    server = "http://your-server:5050",\n  }',
      vim.log.levels.ERROR
    )
    return nil
  end

  local server = user_config.server
  if not server then
    vim.notify(
      "[decent-notes] No server configured in ~/.decent-notes.lua\n"
        .. "Add:\n\n"
        .. '  return {\n    server = "http://your-server:5050",\n  }',
      vim.log.levels.WARN
    )
    return nil
  end

  return {
    "medeirosvictor/decent-notes.nvim",
    config = function()
      require("decent-notes").setup({ server = server })
      vim.keymap.set("n", "<C-n>", "<cmd>DecentNotes<CR>", { desc = "Open Decent Notes" })
    end,
  }
end)()

local plugins = {
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        -- Removed: open_on_setup_file is deprecated
        update_focused_file = { enable = true, update_cwd = false },
        filesystem_watchers = {
          ignore_dirs = { ".claude" },
        },
        filters = { custom = { "^.git$" } },
        git = { enable = true, ignore = true },
        view = { width = 30, side = "left", signcolumn = "yes" },
        renderer = {
          indent_width = 2,
          symlink_destination = false,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              default = "󰈔",
              symlink = "󰌋",
              folder = {
                default = "󰉋",
                open = "󰷏",
                empty = "󰉊",
                empty_open = "󰷏",
                symlink = "󰌋",
                symlink_open = "󰷏",
              },
              git = {
                unstaged = "󰄑",
                staged = "󰄲",
                untracked = "󰊠",
                renamed = "󰁕",
                deleted = "󰀍",
                ignored = "◌",
              },
            },
          },
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git", "dist", "build" },
          mappings = { i = { ["<esc>"] = require("telescope.actions").close } },
        },
        pickers = { find_files = { theme = "dropdown" } },
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = { theme = "auto", component_separators = "|", section_separators = "", globalstatus = true },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-t>]],
        direction = "float",
        float_opts = { border = "curved" },
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = { add = { text = "│" }, change = { text = "│" }, delete = { text = "_" } },
        signcolumn = true,
        on_attach = function(buffer)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          end
          map("n", "]h", gs.next_hunk, "Next Hunk")
          map("n", "[h", gs.prev_hunk, "Prev Hunk")
          map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
          map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        end,
      })
    end,
  },

  { "neovim/nvim-lspconfig" },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )

      local servers = { "ts_ls", "pyright", "gopls", "clangd", "rust_analyzer", "svelte" }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, { capabilities = capabilities })
        vim.lsp.enable(server)
      end

      vim.diagnostic.config({ virtual_text = true, signs = true, float = { border = "rounded" } })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover" })
          vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "Go to references" })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code action" })
        end,
      })

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp" }, { name = "luasnip" }, { name = "path" } },
          { { name = "buffer" } }
        ),
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "python", "go", "rust", "html", "css", "json", "svelte" },
        auto_install = true,
        indent = { enable = true },
      })
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function()
      require("harpoon").setup({})
    end,
  },

  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({ win = { border = "single" } })
    end,
  },

  { "mg979/vim-visual-multi" },

  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup({
        auto_save = true,
        auto_restore = true,
        suppressed_dirs = { "~/", "~/Downloads" },
      })
    end,
  },

  {
    "ej-shafran/compile-mode.nvim",
    version = "^5.0.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.g.compile_mode = {
        default_command = {
          cpp = "c++ -std=c++23 -Wall -o %:r % && ./%:r",
          go  = "go build ./... && go run .",
        },
        auto_jump_to_first_error = true,
        auto_scroll = true,
        ask_about_save = false,
      }

      vim.keymap.set("n", "<leader>cc", "<cmd>Compile<CR>",    { desc = "Compile" })
      vim.keymap.set("n", "<leader>cr", "<cmd>Recompile<CR>",  { desc = "Recompile" })
      vim.keymap.set("n", "<leader>ce", "<cmd>NextError<CR>",  { desc = "Next compile error" })
      vim.keymap.set("n", "<leader>cE", "<cmd>PrevError<CR>",  { desc = "Prev compile error" })
    end,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()

      local api = require("Comment.api")
      -- Normal mode: toggle current line
      vim.keymap.set("n", "<C-/>", api.toggle.linewise.current, { desc = "Toggle comment" })
      -- Visual mode: toggle selection
      vim.keymap.set("v", "<C-/>", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
        api.toggle.linewise(vim.fn.visualmode())
      end, { desc = "Toggle comment" })
    end,
  },

  -- Auto-pairs for brackets
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        fast_wrap = { map = "<M-e>" },
      })
      -- Integrate with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  -- Linting (flake8, pylint, etc.)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "flake8", "pylint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- On-save formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript  = { "prettier" },
          typescript  = { "prettier" },
          svelte      = { "prettier" },
          html        = { "prettier" },
          css         = { "prettier" },
          json        = { "prettier" },
          go          = { "gofmt" },
          rust        = { "rustfmt" },
          python      = { "black" },
          lua         = { "stylua" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true, -- fall back to LSP formatter if tool not installed
        },
      })
    end,
  },

  -- Theme plugins
  { "rebelot/kanagawa.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {
          {
            name = "Kanagawa Wave",
            colorscheme = "kanagawa",
            before = [[
              require("kanagawa").setup({
                compile = false,
                undercurl = true,
                commentStyle = { italic = true },
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                transparent = false,
                dimInactive = false,
                terminalColors = true,
                theme = "wave",
              })
            ]],
          },
          {
            name = "Kanagawa Lotus",
            colorscheme = "kanagawa",
            before = [[
              require("kanagawa").setup({
                compile = false,
                undercurl = true,
                commentStyle = { italic = true },
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                transparent = false,
                dimInactive = false,
                terminalColors = true,
                theme = "lotus",
              })
            ]],
          },
          {
            name = "Nightfox Tera",
            colorscheme = "terafox",
          },
          {
            name = "Nightfox Nord",
            colorscheme = "nordfox",
          },
          {
            name = "Nightfox Dayfox",
            colorscheme = "dayfox",
          },
          {
            name = "Catppuccin Mocha",
            colorscheme = "catppuccin",
            before = [[
              require("catppuccin").setup()
              vim.opt.background = "dark"
            ]],
          },
          {
            name = "Catppuccin Latte",
            colorscheme = "catppuccin",
            before = [[
              require("catppuccin").setup()
              vim.opt.background = "light"
            ]],
          },
        },
        livePreview = true,
      })
      
      -- Set default theme (terafox)
      vim.cmd("colorscheme terafox")
      
      -- Keymap to switch themes
      vim.keymap.set("n", "<leader>ct", ":Themery<CR>", { desc = "Switch theme" })
    end,
  },

  {
    "medeirosvictor/v99",
    dependencies = { "ThePrimeagen/99" },
    config = function()
      local v99 = require("v99")

      v99.setup({
        -- provider = require("v99.providers.pi"),       -- pi with configured default
        -- provider = require("v99.providers.opencode"),  -- opencode with configured default
        -- provider = require("v99.providers.claude"),    -- claude (needs Max/API key)
        -- Switch at runtime with <leader>9c
        completion = {
          source = "native",
        },
      })

      vim.keymap.set("v", "<leader>9v", function()
        v99.api.visual()
      end)

      vim.keymap.set("n", "<leader>9x", function()
        v99.api.stop_all_requests()
      end)

      vim.keymap.set("n", "<leader>9s", function()
        v99.api.search()
      end)

      vim.keymap.set("n", "<leader>9c", function()
        require("99.extensions.telescope").select_provider()
      end, { desc = "Switch AI provider" })
    end,
  },
}

-- Insert decent-notes only if it resolved successfully
if decent_notes_spec then
  table.insert(plugins, 1, decent_notes_spec)
end

require("lazy").setup(plugins, {
  defaults = { lazy = false },
  install = { colorscheme = { "terafox" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "netrwPlugin" },
    },
  },
})

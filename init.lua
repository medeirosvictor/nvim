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

-- Native Neovim 0.11+ commenting (replaces Comment.nvim)
-- gc{motion} / gcc toggle comment; works in normal and visual mode
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("v", "<C-/>", "gc",  { remap = true, desc = "Toggle comment" })

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
  -- ─── Shared deps ───────────────────────────────────────────────────────────
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-neotest/nvim-nio" }, -- shared by nvim-dap-ui and neotest

  -- ─── File Explorer ─────────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        sync_root_with_cwd = true,   -- re-root tree when cwd changes (e.g. project.nvim switch)
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
            file_ignore_patterns = { "node_modules", "dist", "build", ".venv" },
            mappings = { i = { ["<esc>"] = require("telescope.actions").close } },
          },
          pickers = {
            find_files = {
              theme = "dropdown",
              hidden = true,
              no_ignore = true,
              no_ignore_parent = true,
            },
            live_grep = {
              additional_args = function()
                return { "--hidden", "--no-ignore", "--no-ignore-parent" }
              end,
            },
          },
        })
    end,
  },

  -- project.nvim: project switcher — detects projects by .git / pyproject.toml / package.json etc.
  -- <leader>fp: save session → pick project → cd → close buffers → restore session → open tree
  {
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
  },

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = { theme = "auto", component_separators = "|", section_separators = "", globalstatus = true },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", symbols = { modified = " ●" } } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- bufferline: tab bar showing open buffers; harpoon marks shown as pinned tabs
  {
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
  },

  -- alpha-nvim: startup dashboard
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                                    ]],
        [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
        [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
        [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
        [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
        [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
        [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        [[                                                    ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "󰈞  Find file",       ":Telescope find_files<CR>"),
        dashboard.button("g", "󰊄  Live grep",        ":Telescope live_grep<CR>"),
        dashboard.button("r", "  Recent files",     ":Telescope oldfiles<CR>"),
        dashboard.button("s", "  Restore session",  ":SessionRestore<CR>"),
        dashboard.button("h", "󰛢  Harpoon",          ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>"),
        dashboard.button("m", "  Mason",            ":Mason<CR>"),
        dashboard.button("l", "󰒲  Lazy",             ":Lazy<CR>"),
        dashboard.button("q", "  Quit",             ":qa<CR>"),
      }

      dashboard.section.footer.val = "Victor's Neovim"

      alpha.setup(dashboard.opts)

      -- Don't open NvimTree on dashboard
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.cmd("NvimTreeClose")
        end,
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

  -- ─── LSP ───────────────────────────────────────────────────────────────────
  -- vtsls: replaces ts_ls — uses the official VS Code TS extension under the hood,
  --        significantly faster on large TS codebases (e.g. next-wave's 35k+ lines).
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local servers = { "vtsls", "gopls", "clangd", "rust_analyzer", "svelte" }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, { capabilities = capabilities })
        vim.lsp.enable(server)
      end

      vim.diagnostic.config({
        virtual_text = false,  -- disable inline text; use <leader>de or Trouble to see details
        signs        = true,   -- keep gutter squiggly signs (E/W/I/H)
        underline    = true,   -- keep the underline squiggles on the code itself
        float        = { border = "rounded" },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          vim.keymap.set("n", "gd", vim.lsp.buf.definition,    { buffer = buf, desc = "Go to definition" })
          vim.keymap.set("n", "K",  vim.lsp.buf.hover,         { buffer = buf, desc = "Hover" })
          vim.keymap.set("n", "gr", vim.lsp.buf.references,    { buffer = buf, desc = "Go to references" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration,   { buffer = buf, desc = "Go to declaration" })
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation,{ buffer = buf, desc = "Go to implementation" })
          -- <leader>rn → inc-rename.nvim (global keymap, live preview)
          -- <leader>ca → actions-preview.nvim (global keymap, shows diff before apply)
        end,
      })
    end,
  },

  -- Mason: install / update LSP servers, formatters, linters inside Neovim
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        -- run :Mason to install these (automatic_installation = false keeps it opt-in)
        ensure_installed = { "vtsls", "gopls", "rust_analyzer", "svelte" },
        automatic_installation = false,
      })
    end,
  },

  -- ─── Completion ────────────────────────────────────────────────────────────
  -- LuaSnip kept as snippet engine; blink.cmp uses it via snippets.preset = "luasnip"
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },

  -- blink.cmp: Rust-powered completion — replaces nvim-cmp + all its source plugins.
  -- Sources: LSP, path, LuaSnip snippets, buffer words. Cmdline completion built-in.
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "accept", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets  = { preset = "luasnip" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        accept        = { auto_brackets = { enabled = true } },
      },
    },
  },

  -- ─── Treesitter ────────────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "javascript", "typescript", "tsx", "graphql",
          "python", "go", "rust",
          "html", "css", "json", "svelte",
        },
        auto_install = true,
        indent = { enable = true },
      })

      -- textobjects (v1.0 API): configured via nvim-treesitter-textobjects directly
      require("nvim-treesitter-textobjects").setup({
        select = {
          enable    = true,
          lookahead = true,
          keymaps   = {
            ["af"] = "@function.outer", ["if"] = "@function.inner",
            ["ac"] = "@class.outer",    ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer", ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable    = true,
          set_jumps = true,
          goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        },
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

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "lsp", "indent" }
        end,
      })
    end,
  },

  -- ─── Editing ───────────────────────────────────────────────────────────────
  { "mg979/vim-visual-multi" },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        fast_wrap = { map = "<M-e>" },
      })
      -- Note: no nvim-cmp integration needed — blink.cmp handles bracket auto-closing natively
    end,
  },

  -- nvim-surround: wrap motions/selections with quotes, brackets, tags, etc.
  --   ys{motion}{char}  add surround  (e.g. ysiw"  wraps word with "")
  --   ds{char}          delete surround
  --   cs{old}{new}      change surround
  --   S{char}           surround in visual mode
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- ─── Rename / Code Actions ─────────────────────────────────────────────────
  -- inc-rename: live-preview rename — type and see all changes highlighted before confirming
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Rename symbol (live preview)" })
    end,
  },

  -- actions-preview: shows a diff preview of what each code action will do before applying
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      require("actions-preview").setup({
        telescope = { sorting_strategy = "ascending" },
      })
      vim.keymap.set({ "v", "n" }, "<leader>ca",
        require("actions-preview").code_actions,
        { desc = "Code action (preview)" })
    end,
  },

  -- ─── Diagnostics ───────────────────────────────────────────────────────────
  -- trouble.nvim v3: navigable diagnostics panel — replaces the quickfix/loclist workflow
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
    cmd  = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>",                   desc = "Symbols (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                    desc = "Quickfix list" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                   desc = "Location list" },
    },
  },

  -- ─── Symbol Outline ────────────────────────────────────────────────────────
  -- aerial.nvim: sidebar / float showing all symbols; {/} navigate between them per-buffer
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("aerial").setup({
        on_attach = function(bufnr)
          vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Prev symbol" })
          vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next symbol" })
        end,
      })
      vim.keymap.set("n", "<leader>ao", "<cmd>AerialToggle!<CR>", { desc = "Toggle symbol outline" })
    end,
  },
  -- ─── Sessions ──────────────────────────────────────────────────────────────
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup({
        auto_save       = true,
        auto_restore    = true,
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

  -- ─── Linting ───────────────────────────────────────────────────────────────
  -- ruff: replaces flake8+pylint — matches pyproject.toml in waveaccounting/next-accounting
  -- eslint_d: daemon-mode eslint — matches ESLint flat config in next-wave
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python     = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        svelte     = { "eslint_d" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- ─── Formatting ────────────────────────────────────────────────────────────
  -- ruff_format replaces black — matches [tool.ruff] in both Python repos
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          svelte     = { "prettier" },
          html       = { "prettier" },
          css        = { "prettier" },
          json       = { "prettier" },
          go         = { "gofmt" },
          rust       = { "rustfmt" },
          python     = { "ruff_format" }, -- was "black"; matches pyproject.toml
          lua        = { "stylua" },
        },
        formatters = {
          prettier = {
            command = function()
              local local_bin = vim.fn.findfile("node_modules/.bin/prettier", vim.fn.getcwd() .. ";")
              return local_bin ~= "" and local_bin or "prettier"
            end,
          },
        },
        format_on_save = {
          timeout_ms   = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- ─── Debugging (DAP) ───────────────────────────────────────────────────────
  -- nvim-dap-python uses debugpy — supports remote attach for Django in Docker/Okteto.
  -- See :help dap for remote attach config (host/port via DJANGO_DEBUGPY_PORT).
  {
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

      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint,                                             { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end,   { desc = "Conditional breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue,                                                     { desc = "DAP continue" })
      vim.keymap.set("n", "<leader>do", dap.step_over,                                                    { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into,                                                    { desc = "Step into" })
      vim.keymap.set("n", "<leader>dO", dap.step_out,                                                     { desc = "Step out" })
      vim.keymap.set("n", "<leader>du", dapui.toggle,                                                     { desc = "Toggle DAP UI" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open,                                                    { desc = "DAP REPL" })
    end,
  },

  -- ─── Testing ───────────────────────────────────────────────────────────────
  -- neotest-python: pytest adapter (waveaccounting, next-accounting)
  -- neotest-vitest: Vitest adapter (next-wave)
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "marilari88/neotest-vitest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({ dap = { justMyCode = false }, python = "python3" }),
          require("neotest-vitest"),
        },
      })
      -- <leader>tO and <leader>tP use capital letters to avoid conflict with <leader>to (new tab)
      vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run() end,                     { desc = "Run nearest test" })
      vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   { desc = "Run test file" })
      vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end,              { desc = "Test summary" })
      vim.keymap.set("n", "<leader>tO", function() require("neotest").output.open({ enter = true }) end, { desc = "Test output" })
      vim.keymap.set("n", "<leader>tP", function() require("neotest").output_panel.toggle() end,         { desc = "Test output panel" })
      vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, { desc = "Debug nearest test" })
    end,
  },

  -- ─── Git ───────────────────────────────────────────────────────────────────
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    config = function()
      require("diffview").setup()
      vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>",         { desc = "Diff view open" })
      vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<CR>",        { desc = "Diff view close" })
      vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory %<CR>",{ desc = "File git history" })
    end,
  },

  -- ─── QoL Utilities (snacks.nvim) ───────────────────────────────────────────
  -- snacks.notifier    : replaces vim.notify with a modern notification UI
  -- snacks.indent      : indent guides
  -- snacks.words       : highlight all occurrences of the word under cursor
  -- snacks.lazygit     : lazygit in a managed float (<leader>gg / <leader>gl)
  -- snacks.bigfile     : disables heavy plugins for files >1.5 MB (e.g. generated GraphQL)
  -- snacks.scroll      : disabled — conflicts with custom 5-line j/k jumps
  -- snacks.statuscolumn: disabled — conflicts with nvim-ufo fold column
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy     = false,
    opts = {
      notifier     = { enabled = true, timeout = 3000 },
      indent       = { enabled = true },
      words        = { enabled = true },
      lazygit      = { enabled = true },
      bigfile      = { enabled = true },
      scroll       = { enabled = false },
      statuscolumn = { enabled = false },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end,     { desc = "Open Lazygit" })
      vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log() end, { desc = "Lazygit log" })
    end,
  },

  -- ─── Themes ────────────────────────────────────────────────────────────────
  { "rebelot/kanagawa.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "ellisonleao/gruvbox.nvim" },
  { "loctvl842/monokai-pro.nvim" },
  {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
      require("themery").setup({
        themes = {
          {
            name = "Kanagawa Wave",
            colorscheme = "kanagawa-wave",
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
          {
            name = "Gruvbox Dark",
            colorscheme = "gruvbox",
            before = [[
              require("gruvbox").setup({
                contrast = "hard",
                italic = { strings = false, operators = false },
              })
              vim.opt.background = "dark"
            ]],
          },
          {
            name = "Gruvbox Light",
            colorscheme = "gruvbox",
            before = [[
              require("gruvbox").setup({
                contrast = "hard",
                italic = { strings = false, operators = false },
              })
              vim.opt.background = "light"
            ]],
          },
          {
            name = "Monokai Pro Spectrum",
            colorscheme = "monokai-pro",
            before = [[ require("monokai-pro").setup({ filter = "spectrum" }) ]],
          },
          {
            name = "Monokai Pro Classic",
            colorscheme = "monokai-pro",
            before = [[ require("monokai-pro").setup({ filter = "classic" }) ]],
          },
          {
            name = "Monokai Pro Octagon",
            colorscheme = "monokai-pro",
            before = [[ require("monokai-pro").setup({ filter = "octagon" }) ]],
          },
        },
        livePreview = true,
      })

      -- Default theme on startup (Themery remembers your pick after first manual switch)
      require("monokai-pro").setup({ filter = "spectrum" })
      vim.cmd("colorscheme monokai-pro")

      vim.keymap.set("n", "<leader>ct", ":Themery<CR>", { desc = "Switch theme" })
    end,
  },

  -- ─── AI ────────────────────────────────────────────────────────────────────
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

      vim.keymap.set("v", "<leader>9v", function() v99.api.visual() end)
      vim.keymap.set("n", "<leader>9x", function() v99.api.stop_all_requests() end)
      vim.keymap.set("n", "<leader>9s", function() v99.api.search() end)
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

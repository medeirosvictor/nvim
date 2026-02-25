require("victor.core.options")

vim.defer_fn(function()
  require("victor.core.keymaps")
end, 0)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("lazy").setup({
  (function()
    -- User config: ~/.decent-notes.lua
    -- Create this file to override defaults:
    --   return {
    --     server = "http://your-server:5050",
    --     plugin_path = "~/your/custom/path/decent-notes/nvim-plugin",
    --   }
    local config_path = vim.fn.expand("~/.decent-notes.lua")
    local user_config = {}
    if vim.fn.filereadable(config_path) == 1 then
      local ok, cfg = pcall(dofile, config_path)
      if ok and type(cfg) == "table" then
        user_config = cfg
      else
        vim.notify(
          "[decent-notes] Failed to parse ~/.decent-notes.lua\n"
            .. "Ensure it returns a valid Lua table, e.g.:\n\n"
            .. '  return {\n    server = "http://your-server:5050",\n  }',
          vim.log.levels.ERROR
        )
      end
    end

    -- Resolve server URL
    local server = user_config.server
    if not server then
      vim.notify(
        "[decent-notes] No server configured!\n"
          .. "Create ~/.decent-notes.lua with:\n\n"
          .. '  return {\n    server = "http://your-server:5050",\n  }',
        vim.log.levels.WARN
      )
    end

    -- Resolve plugin path
    local search_paths = {
      "~/Projects/decent-notes/nvim-plugin",
      "~/projects/decent-notes/nvim-plugin",
      "~/dev/decent-notes/nvim-plugin",
      "~/src/decent-notes/nvim-plugin",
    }

    local plugin_dir = nil
    if user_config.plugin_path then
      local expanded = vim.fn.expand(user_config.plugin_path)
      if vim.fn.isdirectory(expanded .. "/lua") == 1 then
        plugin_dir = expanded
      else
        vim.notify(
          "[decent-notes] Custom plugin_path not found or invalid:\n"
            .. "  " .. expanded .. "\n\n"
            .. "Ensure nvim-plugin/lua/ exists at that path.",
          vim.log.levels.ERROR
        )
      end
    else
      for _, path in ipairs(search_paths) do
        local expanded = vim.fn.expand(path)
        if vim.fn.isdirectory(expanded .. "/lua") == 1 then
          plugin_dir = expanded
          break
        end
      end
    end

    if not plugin_dir then
      vim.notify(
        "[decent-notes] Plugin not found!\n"
          .. "Clone the repo and ensure nvim-plugin/lua/ exists in one of:\n"
          .. table.concat(vim.tbl_map(vim.fn.expand, search_paths), "\n")
          .. "\n\nOr set a custom path in ~/.decent-notes.lua:\n\n"
          .. '  return {\n    plugin_path = "~/your/path/decent-notes/nvim-plugin",\n  }',
        vim.log.levels.WARN
      )
      return nil
    end

    return {
      dir = plugin_dir,
      name = "decent-notes",
      config = function()
        if server then
          require("decent-notes").setup({ server = server })
          vim.keymap.set("n", "<C-n>", "<cmd>DecentNotes<CR>", { desc = "Open Decent Notes" })
        end
      end,
    }
  end)(),

  { "nvim-lua/plenary.nvim" },

  { "nvim-tree/nvim-web-devicons" },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
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
                ignored = "�esco",
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
        options = { theme = "kanagawa", component_separators = "|", section_separators = "", globalstatus = true },
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



      local servers = { "ts_ls", "pyright", "gopls", "clangd", "rust_analyzer" }
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
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" }, { name = "path" } }, { { name = "buffer" } }),
      })
    end,
  },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "javascript", "typescript", "python", "go", "rust", "html", "css", "json" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
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
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
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
      vim.cmd("colorscheme kanagawa")
    end,
  },

  {
    "pablopunk/pi.nvim",
    config = function()
      require("pi").setup()

      vim.keymap.set("n", "<leader>ai", ":PiAsk<CR>", { desc = "Ask pi" })
      vim.keymap.set("v", "<leader>ai", ":PiAskSelection<CR>", { desc = "Ask pi (selection)" })
    end,
  },
}, {
  defaults = { lazy = false },
  install = { colorscheme = { "kanagawa" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "netrwPlugin" },
    },
  },
})

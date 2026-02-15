# Neovim Configuration

A modern Neovim setup using the built-in `vim.pack` package manager with Lua configuration.

## File Structure

```
nvim/
├── init.lua              # Main entry point - loads all config modules
├── lua/victor/
│   ├── core/
│   │   ├── options.lua   # General editor settings (indentation, colors, behavior)
│   │   ├── keymaps.lua   # Keyboard shortcuts
│   │   └── autocmds.lua  # Automatic commands (events triggered on actions)
│   ├── plugins/
│   │   └── init.lua      # Plugin configurations and vim.pack.add() calls
│   └── languages/
│       ├── lsp.lua       # LSP (Language Server Protocol) configuration
│       └── treesitter.lua# Treesitter syntax highlighting setup
└── README.md             # This file
```

## Where to Make Changes

### Adding/Removing Plugins
Edit `lua/victor/plugins/init.lua` - look for the `plugins` table at the top. Add new plugins using:
```lua
{ src = "https://github.com/username/plugin_name" }
```

### Changing Keybindings
Edit `lua/victor/core/keymaps.lua`. Use `vim.keymap.set()` with the format:
```lua
keymap("mode", "shortcut", "action", { options, desc = "description" })
```

### Editor Settings
Edit `lua/victor/core/options.lua` - contains options like:
- `tabstop`, `shiftwidth` - indentation
- `relativenumber`, `number` - line numbers
- `termguicolors` - true color support
- etc.

### LSP/Language Servers
Edit `lua/victor/languages/lsp.lua` to:
- Add/remove language servers in `ensure_installed`
- Configure LSP keybindings
- Set up completion (nvim-cmp)

### Treesitter Languages
Edit `lua/victor/languages/treesitter.lua` - add languages to `ensure_installed` list.

## Installed Plugins

### Core
- **nvim-tree/nvim-tree.lua** - File explorer sidebar
- **nvim-tree/nvim-web-devicons** - File icons
- **nvim-lualine/lualine.nvim** - Status line
- **folke/which-key.nvim** - Keybinding popup helper

### Fuzzy Finding
- **nvim-telescope/telescope.nvim** - Fuzzy finder (files, grep, etc.)
- **nvim-telescope/telescope-themes** - Theme picker

### Git
- **lewis6991/gitsigns.nvim** - Git signs in gutter

### Terminal
- **akinsho/toggleterm.nvim** - Embedded terminal

### Completion
- **hrsh7th/nvim-cmp** - Completion framework
- **hrsh7th/cmp-nvim-lsp** - LSP completion source
- **hrsh7th/cmp-buffer** - Buffer completion
- **hrsh7th/cmp-path** - Path completion
- **hrsh7th/cmp-cmdline** - Command line completion
- **saadparwaiz1/cmp_luasnip** - Snippet completion

### Snippets
- **L3MON4D3/LuaSnip** - Snippet engine

### LSP & Languages
- **neovim/nvim-lspconfig** - LSP client configuration
- **williamboman/mason.nvim** - LSP server installer
- **williamboman/mason-lspconfig.nvim** - Mason + LSP config integration
- **nvim-treesitter/nvim-treesitter** - Syntax highlighting

### Multi-cursor
- **mg979/vim-visual-multi** - Multiple cursors (Ctrl+D / Ctrl+R)

### Navigation
- **ThePrimeagen/harpoon** - Quick file marking/navigation (harpoon2)

### Themes
- **ellisonleao/gruvbox.nvim** - Gruvbox dark theme (default)

## Keybindings

| Shortcut | Action |
|----------|--------|
| `Space` | Show which-key popup (all available commands) |
| `Ctrl+F` | Find text in files (Telescope live_grep) |
| `Ctrl+P` | Find file (Telescope find_files) |
| `Ctrl+B` | Toggle sidebar (nvim-tree) |
| `Ctrl+T` | Toggle terminal |
| `Ctrl+Shift+T` | Pick theme (Telescope themes) |
| `Ctrl+D` | Select next occurrence (visual-multi) |
| `Ctrl+R` | Multi-cursor replace (visual mode) |

### Window Navigation
| Shortcut | Action |
|----------|--------|
| `Ctrl+h/j/k/l` | Navigate windows |
| `Space+sv` | Split vertically |
| `Space+sh` | Split horizontally |

### Tab Navigation
| Shortcut | Action |
|----------|--------|
| `Space+to` | New tab |
| `Space+tx` | Close tab |
| `Space+tn` | Next tab |
| `Space+tp` | Previous tab |

### Harpoon
| Shortcut | Action |
|----------|--------|
| `Space+a` | Add file to harpoon |
| `Space+hh` | Open harpoon menu |
| `Space+h1-4` | Jump to harpoon mark 1-4 |

### LSP
| Shortcut | Action |
|----------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `K` | Hover |
| `gi` | Go to implementation |
| `gr` | Go to references |
| `rn` | Rename |
| `ca` | Code action |
| `[d` / `]d` | Previous/Next diagnostic |

### Telescope
| Shortcut | Action |
|----------|--------|
| `Space+ff` | Find files |
| `Space+fg` | Find text (live grep) |
| `Space+fb` | Find buffers |
| `Space+fh` | Find help tags |

### Git (gitsigns)
| Shortcut | Action |
|----------|--------|
| `[h` / `]h` | Previous/Next hunk |
| `Space+ghs` | Stage hunk |
| `Space+ghr` | Reset hunk |

## First Setup

1. Open Neovim - plugins will install automatically via `vim.pack`
2. Restart Neovim (`:Restart` or close and reopen)
3. Install LSP servers: Run `:Mason` and install desired servers
4. Install treesitter parsers: Run `:TSUpdateSync` or restart nvim

## Theme

Default theme is **gruvbox** (dark mode). Use `Ctrl+Shift+T` to pick a different theme via Telescope.

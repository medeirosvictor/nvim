# Neovim Configuration

A modern Neovim setup using [lazy.nvim](https://github.com/folke/lazy.nvim) with Lua configuration.

## Requirements

- **Neovim 0.11+** — `apt install neovim` often gives older versions, so grab the latest from [GitHub releases](https://github.com/neovim/neovim/releases)
- **git** — required for lazy.nvim plugin management
- **C compiler** (gcc/clang) — required for treesitter parser compilation
- **A Nerd Font** — required for icons ([nerdfonts.com](https://www.nerdfonts.com/))

### Optional (for full LSP support)

- `node` + `npm` — for ts_ls, pyright, eslint
- `python3` — for pyright
- `go` — for gopls
- `cargo` — for rust-analyzer
- `ripgrep` (`rg`) — for telescope live_grep
- `fd` — for faster telescope file finding

## Quick Start

```bash
# Clone to your config directory
git clone https://github.com/YOUR_USER/nvim.git ~/.config/nvim

# Open Neovim — plugins install automatically on first launch
nvim
```

Run `:checkhealth victor` to verify all dependencies are present.

## File Structure

```
nvim/
├── init.lua                    # Entry point — plugin definitions, lazy.nvim bootstrap
├── lua/victor/
│   ├── core/
│   │   ├── options.lua         # Editor settings (indentation, colors, behavior)
│   │   ├── keymaps.lua         # Keyboard shortcuts
│   │   └── autocmds.lua        # Autocommands (yank highlight, format options, etc.)
│   └── health/
│       └── init.lua            # :checkhealth victor — dependency checker
├── lazy-lock.json              # Plugin version lockfile
└── README.md
```

## Where to Make Changes

### Adding/Removing Plugins
Edit `init.lua` — find the `plugins` table and add/remove lazy.nvim plugin specs.

### Changing Keybindings
Edit `lua/victor/core/keymaps.lua`.

### Editor Settings
Edit `lua/victor/core/options.lua` — indentation, line numbers, clipboard, etc.

### LSP Servers
Edit `init.lua` — find the `servers` table inside the nvim-cmp config block. LSP servers must be installed on your system (e.g. via `npm install -g typescript-language-server`).

### Treesitter Languages
Edit `init.lua` — find the `ensure_installed` list inside the nvim-treesitter config block.

## Installed Plugins

### Core
- **nvim-tree.lua** — file explorer sidebar
- **nvim-web-devicons** — file icons
- **lualine.nvim** — status line (kanagawa theme)
- **which-key.nvim** — keybinding popup helper

### Fuzzy Finding
- **telescope.nvim** — fuzzy finder (files, grep, buffers)

### Git
- **gitsigns.nvim** — git signs in gutter, hunk staging/resetting

### Terminal
- **toggleterm.nvim** — floating terminal

### Completion & LSP
- **nvim-cmp** — completion framework (with buffer, path, LSP, snippet sources)
- **LuaSnip** — snippet engine
- **nvim-lspconfig** — LSP client configuration
- LSP configured via `vim.lsp.config()` / `vim.lsp.enable()` (Neovim 0.11+ native)

### Navigation
- **harpoon** (v2) — quick file marking/navigation

### Multi-cursor
- **vim-visual-multi** — multiple cursors

### Theme
- **kanagawa.nvim** — kanagawa wave theme

### AI
- **pi.nvim** — AI assistant integration

### Optional
- **decent-notes** — personal notes plugin (only loads if `~/.decent-notes.lua` exists)

## Keybindings

| Shortcut | Action |
|----------|--------|
| `Space` | Leader key (shows which-key popup) |
| `Ctrl+P` | Find files (telescope) |
| `Ctrl+F` | Find text in current buffer |
| `Ctrl+Shift+F` | Find text in all files (live grep) |
| `Ctrl+B` | Toggle file tree sidebar |
| `Ctrl+T` | Toggle floating terminal |

### File Navigation
| Shortcut | Action |
|----------|--------|
| `Space+ff` | Find files |
| `Space+fg` | Live grep |
| `Space+fb` | Find buffers |
| `Space+fh` | Find help tags |
| `Space+e` | Focus file tree |

### Window Navigation
| Shortcut | Action |
|----------|--------|
| `Ctrl+h/j/k/l` | Navigate between windows |
| `Space+sv` | Split vertically |
| `Space+sh` | Split horizontally |

### Tabs
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
| `Space+h1–h4` | Jump to harpoon mark 1–4 |

### LSP
| Shortcut | Action |
|----------|--------|
| `gd` | Go to definition |
| `K` | Hover documentation |
| `gr` | Go to references |
| `Space+rn` | Rename symbol |
| `Space+ca` | Code action |

### Git (gitsigns)
| Shortcut | Action |
|----------|--------|
| `]h` / `[h` | Next / previous hunk |
| `Space+ghs` | Stage hunk |
| `Space+ghr` | Reset hunk |

### Other
| Shortcut | Action |
|----------|--------|
| `j` / `k` | Jump 5 lines (normal & visual mode) |
| `Space+h` | Clear search highlight |
| `Space+th` | Pick colorscheme |
| `Space+ai` | Ask pi (AI) |
| `Space+r` (visual) | Replace all occurrences of selection |

## Decent Notes (Optional)

If you use [decent-notes.nvim](https://github.com/medeirosvictor/decent-notes.nvim), create `~/.decent-notes.lua`:

```lua
return {
  server = "http://your-server:5050",
}
```

The plugin is fetched from GitHub via lazy.nvim and only loads when this file exists. No warnings on machines without it.

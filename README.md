# Neovim Configuration

A modern Neovim setup (0.11+) using [lazy.nvim](https://github.com/folke/lazy.nvim).

---

## Requirements

| Dependency | Purpose |
|---|---|
| **Neovim 0.11+** | Required — grab from [GitHub releases](https://github.com/neovim/neovim/releases), distro packages are often too old |
| **git** | Plugin management (lazy.nvim) |
| **C compiler** (gcc/clang) | Treesitter parser compilation + telescope-fzf-native |
| **A Nerd Font** | Icons — [nerdfonts.com](https://www.nerdfonts.com/) |

### External tools (LSP, lint, format, search, debug)

| Tool | Purpose |
|---|---|
| `node` + `npm` | vtsls (TypeScript), svelte LSP |
| `python3` + `pip` | debugpy (DAP) |
| `go` | gopls |
| `cargo` | rust-analyzer |
| `ruff` | Python linter + formatter (`pip install ruff`) |
| `eslint_d` | TypeScript/JS linter daemon (`npm i -g eslint_d`) |
| `prettier` | TS/JS/CSS/JSON formatter (`npm i -g prettier`) |
| `stylua` | Lua formatter (`brew install stylua`) |
| `lazygit` | Git TUI (`brew install lazygit`) |
| `ripgrep` (`rg`) | Telescope live grep (`brew install ripgrep`) |
| `fd` | Fast file finder for Telescope (`brew install fd`) |

---

## Installation

### macOS

```bash
# 1. Install Neovim 0.11+
brew install neovim

# 2. Install external tools
brew install git ripgrep fd lazygit stylua
npm install -g vtsls prettier eslint_d
pip install ruff debugpy

# 3. Clone config
git clone https://github.com/medeirosvictor/nvim.git ~/.config/nvim

# 4. Open Neovim — lazy.nvim installs all plugins automatically
nvim
```

### Linux (Debian/Ubuntu)

```bash
# 1. Install Neovim 0.11+ (distro package is often outdated — use tarball)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-x86_64.tar.gz && sudo mv nvim-linux-x86_64 /opt/nvim
echo 'export PATH="$PATH:/opt/nvim/bin"' >> ~/.bashrc && source ~/.bashrc

# 2. Install external tools
sudo apt install -y git ripgrep fd-find build-essential nodejs npm python3 python3-pip
npm install -g vtsls prettier eslint_d
pip install ruff debugpy
# lazygit: https://github.com/jesseduffield/lazygit#ubuntu
# stylua: https://github.com/JohnnyMorganz/StyLua/releases

# 3. Clone config
git clone https://github.com/medeirosvictor/nvim.git ~/.config/nvim

# 4. Open Neovim
nvim
```

---

## First Launch

1. lazy.nvim bootstraps itself and installs all plugins (~30–60 seconds). A progress UI shows the status.
2. Mason auto-installs the LSP servers (`vtsls`, `gopls`, `rust_analyzer`, `svelte`). Run `:Mason` to manage others manually.
3. Treesitter parsers auto-install on first file open (`auto_install = true`).
4. If any plugin build step fails (blink.cmp, LuaSnip, telescope-fzf-native), run `:Lazy build <plugin-name>`.

---

## File Structure

```
nvim/
├── init.lua                  # Entry point — bootstraps lazy.nvim, loads plugins
├── lazy-lock.json            # Plugin version lockfile (commit this)
├── README.md
└── lua/
    ├── config/
    │   ├── options.lua       # Editor settings (tabs, clipboard, folding, etc.)
    │   ├── keymaps.lua       # Global keybindings
    │   └── autocmds.lua      # Autocommands (yank highlight, etc.)
    └── plugins/              # One file per plugin (or logical group)
```

---

## Plugins

### Navigation & Search
| Plugin | Purpose |
|---|---|
| **telescope.nvim** + **telescope-fzf-native** | Fuzzy finder — files, grep, buffers, help. fzf-native adds a native C sorter for fast matching |
| **harpoon** (v2) | Quick-mark up to 4 files and jump between them instantly |
| **grug-far.nvim** | Project-wide search & replace with live preview |

### LSP & Completion
| Plugin | Purpose |
|---|---|
| **nvim-lspconfig** | LSP client — vtsls, gopls, clangd, rust_analyzer, svelte, basedpyright |
| **blink.cmp** | Rust-powered completion (LSP, path, snippets, buffer words) |
| **LuaSnip** | Snippet engine (used by blink.cmp) |
| **mason.nvim** + **mason-lspconfig** | Install/manage LSP servers, linters, formatters (`:Mason`) |
| **inc-rename.nvim** | Live-preview symbol rename |
| **actions-preview.nvim** | Diff-preview before applying code actions |

### Treesitter
| Plugin | Purpose |
|---|---|
| **nvim-treesitter** | Syntax highlighting, indentation — auto-installs parsers |
| **nvim-treesitter-textobjects** | `af/if` (function), `ac/ic` (class), `aa/ia` (argument) text objects |

### Git
| Plugin | Purpose |
|---|---|
| **gitsigns.nvim** | Gutter signs, hunk staging/reset, hunk navigation |
| **snacks.lazygit** | Lazygit in a managed float |

### Linting & Formatting
| Plugin | Tools |
|---|---|
| **nvim-lint** | `ruff` (Python), `eslint_d` (TS/JS/Svelte) — runs on save and insert leave |
| **conform.nvim** | `ruff_format` (Python), `prettier` (TS/JS/CSS/JSON/Svelte), `gofmt`, `rustfmt`, `stylua` — formats on save |

### Debugging
| Plugin | Purpose |
|---|---|
| **nvim-dap** + **nvim-dap-ui** + **nvim-dap-virtual-text** | Debug Adapter Protocol — breakpoints, step through, variable inspection |
| **nvim-dap-python** | Python debugpy adapter (supports remote attach for Docker/Okteto) |

### UI & QoL
| Plugin | Purpose |
|---|---|
| **lualine.nvim** | Status line |
| **aerial.nvim** | Symbol outline sidebar — navigate functions/classes with `{`/`}` |
| **trouble.nvim** | Diagnostics and quickfix panel |
| **nvim-ufo** | LSP-powered code folding |
| **which-key.nvim** | Keymap popup after leader pause |
| **toggleterm.nvim** | Floating terminal |
| **snacks.nvim** | Notifications, indent guides, word highlights, bigfile guard |
| **auto-session** | Automatic session save/restore per working directory |

### Editing
| Plugin | Purpose |
|---|---|
| **nvim-surround** | Add/change/delete surrounding quotes, brackets, tags |
| **nvim-autopairs** | Auto-close brackets and quotes |
| **vim-visual-multi** | Multiple cursors |

### AI
| Plugin | Purpose |
|---|---|
| **decent-notes** | Personal notes panel — only loads if `~/.decent-notes.lua` exists |

### Theme
**Ayu Dark** (`neovim-ayu`). Switch at runtime with `<leader>th` (Telescope colorscheme picker).

---

## Keybindings

`Space` is the **leader key**. Which-key shows available keys after a short pause.

### Global
| Key | Action |
|---|---|
| `<C-p>` | Find files (Telescope, searches from workspace root) |
| `<C-S-f>` | Live grep (Telescope, searches from workspace root) |
| `<C-f>` | Search & replace — grug-far (normal mode) |
| `<C-f>` | Search & replace with selection pre-filled (visual mode) |
| `<C-t>` | Toggle floating terminal |
| `<C-/>` | Toggle comment (line or selection — native Neovim 0.11+) |
| `<M-e>` | Autopairs fast-wrap |
| `<C-h/j/k/l>` | Move to window left/down/up/right |
| `<C-n>` | Open Decent Notes (only if `~/.decent-notes.lua` exists) |

### Telescope / Search
| Key | Action |
|---|---|
| `<leader>ff` / `<leader>e` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find open buffers |
| `<leader>fh` | Find help tags |
| `<leader>th` | Pick colorscheme |

### Harpoon
| Key | Action |
|---|---|
| `<leader>a` | Add current file to harpoon |
| `<leader>hh` | Open harpoon menu |
| `<leader>h1` – `<leader>h4` | Jump to harpoon mark 1–4 |

### Buffers
| Key | Action |
|---|---|
| `<leader>q` | Close current buffer |

### Windows & Tabs
| Key | Action |
|---|---|
| `<leader>sv` / `<leader>sh` | Split vertically / horizontally |
| `<leader>to` | New tab |
| `<leader>tx` | Close tab |
| `<leader>tn` / `<leader>tp` | Next / prev tab |

### LSP
| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Go to references |
| `K` | Hover documentation |
| `gK` / `<C-k>` (insert) | Signature help |
| `<leader>rn` | Rename symbol (live preview) |
| `<leader>ca` | Code action (diff preview before apply) |
| `<leader>de` | Show diagnostic float |

### Diagnostics / Trouble
| Key | Action |
|---|---|
| `<leader>xx` | Workspace diagnostics (Trouble) |
| `<leader>xX` | Buffer diagnostics (Trouble) |
| `<leader>xs` | Symbols (Trouble) |
| `<leader>xq` | Quickfix list (Trouble) |
| `<leader>xl` | Location list (Trouble) |

### Git
| Key | Action |
|---|---|
| `]h` / `[h` | Next / prev hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>gg` | Open Lazygit float |
| `<leader>gl` | Lazygit log |

### Debugging (DAP)
| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>dO` | Step out |
| `<leader>du` | Toggle DAP UI |
| `<leader>dr` | Open REPL |

### Symbol Outline (aerial)
| Key | Action |
|---|---|
| `<leader>ao` | Toggle symbol outline |
| `{` / `}` | Prev / next symbol in file |

### Folding (nvim-ufo)
| Key | Action |
|---|---|
| `zR` | Open all folds |
| `zM` | Close all folds |

### Surround (nvim-surround)
| Key | Action |
|---|---|
| `ys{motion}{char}` | Add surround — e.g. `ysiw"` wraps word in `""` |
| `yss{char}` | Surround entire line |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround — e.g. `cs"'` |
| `S{char}` | Surround visual selection |

### Treesitter Text Objects
| Key | Action |
|---|---|
| `af` / `if` | Around / inside function |
| `ac` / `ic` | Around / inside class |
| `aa` / `ia` | Around / inside argument |
| `]f` / `[f` | Jump to next / prev function |
| `]c` / `[c` | Jump to next / prev class |

### Misc
| Key | Action |
|---|---|
| `<leader>fd` | Delete current file |
| `<leader>h` | Clear search highlight |
| `<leader>r` (visual) | Replace all occurrences of selection in buffer |

---

## Optional: Decent Notes

Create `~/.decent-notes.lua` to enable the personal notes plugin:

```lua
return {
  server = "http://your-server:5050",
}
```

`<C-n>` opens the notes panel. The plugin does not load at all if this file is absent.

---

## Updating

```vim
:Lazy update        " update all plugins
:Lazy sync          " install missing + update + clean unused
:TSUpdate           " update treesitter parsers
:Mason              " manage LSP servers / linters / formatters
```

Commit `lazy-lock.json` after updating to pin plugin versions across machines.

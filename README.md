# Neovim Configuration

A modern Neovim setup (0.11+) using [lazy.nvim](https://github.com/folke/lazy.nvim).

---

## Requirements

| Dependency | Purpose |
|---|---|
| **Neovim 0.11+** | Required. Grab the latest from [GitHub releases](https://github.com/neovim/neovim/releases) — distro packages are often too old. |
| **git** | Plugin management (lazy.nvim) |
| **C compiler** (gcc/clang) | Treesitter parser compilation |
| **tree-sitter CLI** | `brew install tree-sitter` or `npm i -g tree-sitter-cli` |
| **A Nerd Font** | Icons — [nerdfonts.com](https://www.nerdfonts.com/) |

### Tools for full LSP / lint / format / debug support

Run `:checkhealth victor` after first launch to see what's missing.

| Tool | Purpose |
|---|---|
| `node` + `npm` | vtsls (TypeScript), basedpyright, svelte LSPs |
| `python3` + `pip` | basedpyright, debugpy (DAP), neotest-python |
| `go` | gopls |
| `cargo` | rust-analyzer |
| `ruff` | Python linter + formatter (`pip install ruff`) |
| `eslint_d` | TypeScript/JS linter daemon (`npm i -g eslint_d`) |
| `prettier` | TS/JS/CSS/JSON formatter (`npm i -g prettier`) |
| `stylua` | Lua formatter (`brew install stylua` or via cargo) |
| `lazygit` | Git TUI via snacks.lazygit (`brew install lazygit`) |
| `ripgrep` (`rg`) | Telescope live grep |
| `fd` | Faster Telescope file finding |

---

## Installation

### macOS

```bash
# 1. Install Neovim 0.11+
brew install neovim

# 2. Install dependencies
brew install git ripgrep fd lazygit stylua tree-sitter
npm install -g typescript-language-server vtsls prettier eslint_d
pip install basedpyright ruff debugpy

# 3. Clone this config
git clone https://github.com/medeirosvictor/nvim.git ~/.config/nvim

# 4. Open Neovim — lazy.nvim installs all plugins automatically on first launch
nvim
```

### Linux (Debian/Ubuntu)

```bash
# 1. Install Neovim 0.11+ (distro package is likely outdated — use the AppImage or tarball)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64 /opt/nvim
echo 'export PATH="$PATH:/opt/nvim/bin"' >> ~/.bashrc && source ~/.bashrc

# 2. Install dependencies
sudo apt install -y git ripgrep fd-find build-essential nodejs npm python3 python3-pip
npm install -g vtsls prettier eslint_d
pip install basedpyright ruff debugpy
# stylua: download from https://github.com/JohnnyMorganz/StyLua/releases
# lazygit: https://github.com/jesseduffield/lazygit#ubuntu

# 3. Clone this config
git clone https://github.com/medeirosvictor/nvim.git ~/.config/nvim

# 4. Open Neovim
nvim
```

### Windows (PowerShell + winget)

```powershell
# 1. Install Neovim
winget install Neovim.Neovim

# 2. Install dependencies
winget install BurntSushi.ripgrep.MSVC sharkdp.fd jesseduffield.lazygit
npm install -g vtsls prettier eslint_d
pip install basedpyright ruff debugpy

# 3. Clone this config (PowerShell)
git clone https://github.com/medeirosvictor/nvim.git "$env:LOCALAPPDATA\nvim"

# 4. Open Neovim
nvim
```

> **Note for Windows:** A C compiler is needed for treesitter. Install Visual Studio Build Tools or LLVM (`winget install LLVM.LLVM`).

---

## First Launch

1. On first open, lazy.nvim automatically clones and installs all plugins.  
   This takes ~30–60 seconds — you'll see a progress UI.

2. Some plugins have build steps (blink.cmp, LuaSnip). If they fail, run `:Lazy build blink.cmp` / `:Lazy build LuaSnip`.

3. Run `:checkhealth victor` to verify all external tools are present.

4. Install LSP servers via Mason: `:Mason` → browse and press `i` to install.  
   The config auto-enables: `vtsls`, `basedpyright`, `gopls`, `clangd`, `rust_analyzer`, `svelte`.

5. Install treesitter parsers: `:TSUpdate` (most install automatically on first file open).

---

## File Structure

```
nvim/
├── init.lua                    # Entry point — all plugin specs and config
├── lua/victor/
│   ├── core/
│   │   ├── options.lua         # Editor settings (tabs, clipboard, colors, folds)
│   │   ├── keymaps.lua         # Global keyboard shortcuts
│   │   └── autocmds.lua        # Autocommands (yank highlight, indent, etc.)
│   └── health/
│       └── init.lua            # :checkhealth victor — dependency checker
├── lazy-lock.json              # Plugin version lockfile (commit this)
└── README.md
```

### Where to make changes

| What | Where |
|---|---|
| Add/remove plugins | `init.lua` — find the relevant `-- ─── Section` block |
| Global keybindings | `lua/victor/core/keymaps.lua` |
| Editor settings | `lua/victor/core/options.lua` |
| LSP servers | `init.lua` — find `local servers = { ... }` |
| Treesitter languages | `init.lua` — find `ensure_installed = { ... }` |
| Lint tools per filetype | `init.lua` — find `lint.linters_by_ft` |
| Format tools per filetype | `init.lua` — find `formatters_by_ft` |

---

## Plugins

### Core
| Plugin | Purpose |
|---|---|
| **nvim-tree.lua** | File explorer sidebar |
| **telescope.nvim** | Fuzzy finder (files, grep, buffers, help) |
| **lualine.nvim** | Status line |
| **which-key.nvim** | Keybinding popup helper |
| **toggleterm.nvim** | Floating terminal |
| **auto-session** | Automatic session save/restore |
| **harpoon** (v2) | Quick file marking and navigation |
| **vim-visual-multi** | Multiple cursors |
| **nvim-ufo** | Better code folding (LSP + indent) |

### LSP & Completion
| Plugin | Purpose |
|---|---|
| **nvim-lspconfig** | LSP client (vtsls, basedpyright, gopls, clangd, rust_analyzer, svelte) |
| **blink.cmp** | Rust-powered completion (replaces nvim-cmp) |
| **LuaSnip** | Snippet engine |
| **mason.nvim** | LSP / linter / formatter installer (`:Mason`) |
| **mason-lspconfig.nvim** | Bridge between Mason and lspconfig |
| **inc-rename.nvim** | Live-preview rename |
| **actions-preview.nvim** | Diff-preview before applying code actions |

### Treesitter
| Plugin | Purpose |
|---|---|
| **nvim-treesitter** | Syntax highlighting, indentation |
| **nvim-treesitter-textobjects** | `af/if` (function), `ac/ic` (class), `aa/ia` (argument) text objects |

### Git
| Plugin | Purpose |
|---|---|
| **gitsigns.nvim** | Git signs in gutter, hunk staging/reset |
| **diffview.nvim** | Side-by-side diff view and file history |
| **snacks.lazygit** | Lazygit in a managed float |

### Linting & Formatting
| Plugin | Linters/Formatters |
|---|---|
| **nvim-lint** | `ruff` (Python), `eslint_d` (TS/JS/Svelte) |
| **conform.nvim** | `ruff_format` (Python), `prettier` (TS/JS/CSS/JSON), `gofmt`, `rustfmt`, `stylua` |

### Debugging
| Plugin | Purpose |
|---|---|
| **nvim-dap** | Debug Adapter Protocol client |
| **nvim-dap-ui** | Debugger UI (variables, callstack, breakpoints panels) |
| **nvim-dap-virtual-text** | Inline variable values while debugging |
| **nvim-dap-python** | Python debugpy adapter (supports remote attach for Docker/Okteto) |

### Testing
| Plugin | Purpose |
|---|---|
| **neotest** | Test runner framework |
| **neotest-python** | pytest adapter |
| **neotest-vitest** | Vitest adapter |

### QoL
| Plugin | Purpose |
|---|---|
| **snacks.nvim** | Notifications, indent guides, word highlight, bigfile guard |
| **trouble.nvim** | Diagnostics/quickfix panel |
| **aerial.nvim** | Symbol outline sidebar (`{`/`}` to navigate) |
| **nvim-surround** | Add/change/delete surrounding quotes, brackets, tags |
| **nvim-autopairs** | Auto-close brackets and quotes |
| **compile-mode.nvim** | Emacs-style compile buffer |

### Themes
Kanagawa Wave (default), Kanagawa Lotus, Terafox, Nordfox, Dayfox, Catppuccin Mocha, Catppuccin Latte.
Switch with `<leader>ct` (Themery live preview).

### AI
- **v99** — AI assistant (supports pi, opencode, claude providers; switch at runtime with `<leader>9c`)
- **decent-notes** — Personal notes plugin (optional; loads only if `~/.decent-notes.lua` exists)

---

## Keybindings

`Space` is the **leader key**. Which-key shows available keys after a short pause.  
Neovim 0.11+ native commenting: `gc{motion}` / `gcc` toggle line, `<C-/>` shortcut below.

### Global
| Shortcut | Action |
|---|---|
| `<C-p>` | Find files (Telescope) |
| `<C-f>` / `<C-S-F>` | Live grep (Telescope) |
| `<C-b>` | Toggle file tree |
| `<C-t>` | Toggle floating terminal |
| `<C-/>` | Toggle comment (line / selection) |
| `<M-e>` | Autopairs fast-wrap |
| `j` / `k` | Jump **5 lines** down/up (normal & visual) |
| `↓` / `↑` | Jump 1 line (arrow keys) |

### Telescope / Search
| Shortcut | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find open buffers |
| `<leader>fh` | Find help tags |
| `<leader>th` | Pick colorscheme (Telescope) |

### File Tree
| Shortcut | Action |
|---|---|
| `<leader>e` | Focus file tree |
| `<C-b>` | Toggle file tree |

### Window Navigation
| Shortcut | Action |
|---|---|
| `<C-h/j/k/l>` | Move to window left/down/up/right |
| `<leader>sv` | Split vertically |
| `<leader>sh` | Split horizontally |

### Tabs
| Shortcut | Action |
|---|---|
| `<leader>to` | New tab |
| `<leader>tx` | Close tab |
| `<leader>tn` | Next tab |
| `<leader>tp` | Previous tab |

### Harpoon (quick file marks)
| Shortcut | Action |
|---|---|
| `<leader>a` | Add file to harpoon |
| `<leader>hh` | Open harpoon menu |
| `<leader>h1`–`h4` | Jump to harpoon mark 1–4 |

### LSP
| Shortcut | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol (live preview via inc-rename) |
| `<leader>ca` | Code action (diff preview via actions-preview) |
| `<leader>de` | Show diagnostic float |

### Surround (nvim-surround)
| Shortcut | Action |
|---|---|
| `ys{motion}{char}` | Add surround — e.g. `ysiw"` wraps word with `""` |
| `yss{char}` | Surround entire line |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround — e.g. `cs"'` changes `""` to `''` |
| `S{char}` | Surround visual selection |

### Treesitter Text Objects
| Shortcut | Action |
|---|---|
| `af` / `if` | Around / inside **function** |
| `ac` / `ic` | Around / inside **class** |
| `aa` / `ia` | Around / inside **argument** |
| `]f` / `[f` | Jump to next / prev function start |
| `]c` / `[c` | Jump to next / prev class start |

### Git
| Shortcut | Action |
|---|---|
| `]h` / `[h` | Next / prev hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>gg` | Open Lazygit float |
| `<leader>gl` | Lazygit log |
| `<leader>gd` | Open diff view |
| `<leader>gD` | Close diff view |
| `<leader>gH` | File git history (diffview) |

### Diagnostics / Trouble
| Shortcut | Action |
|---|---|
| `<leader>de` | Show diagnostic float |
| `<leader>xx` | Workspace diagnostics (Trouble) |
| `<leader>xX` | Buffer diagnostics (Trouble) |
| `<leader>xs` | Symbols (Trouble) |
| `<leader>xq` | Quickfix list (Trouble) |
| `<leader>xl` | Location list (Trouble) |

### Symbol Outline (aerial)
| Shortcut | Action |
|---|---|
| `<leader>ao` | Toggle symbol outline |
| `{` / `}` | Prev / next symbol (per buffer) |

### Folding (nvim-ufo)
| Shortcut | Action |
|---|---|
| `zR` | Open all folds |
| `zM` | Close all folds |

### Debugging (DAP)
| Shortcut | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>dO` | Step out |
| `<leader>du` | Toggle DAP UI |
| `<leader>dr` | Open REPL |

> **Docker/Okteto remote debugging:** Configure a remote attach in `init.lua` under the DAP section.  
> Example: `dap.configurations.python` with `{ request = "attach", host = "localhost", port = 5678 }`.

### Testing (neotest)
| Shortcut | Action |
|---|---|
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run test file |
| `<leader>ts` | Toggle test summary |
| `<leader>tO` | Open test output |
| `<leader>tP` | Toggle test output panel |
| `<leader>td` | Debug nearest test (neotest + DAP) |

### Compilation (compile-mode)
| Shortcut | Action |
|---|---|
| `<leader>cc` | Compile |
| `<leader>cr` | Recompile (repeat last) |
| `<leader>ce` | Jump to next compile error |
| `<leader>cE` | Jump to prev compile error |

### Themes
| Shortcut | Action |
|---|---|
| `<leader>ct` | Open Themery (live preview theme switcher) |
| `<leader>th` | Pick colorscheme via Telescope |

### AI (v99)
| Shortcut | Action |
|---|---|
| `<leader>9v` | Visual selection to AI (visual mode) |
| `<leader>9s` | AI search |
| `<leader>9x` | Stop all AI requests |
| `<leader>9c` | Switch AI provider (Telescope picker) |

### Misc
| Shortcut | Action |
|---|---|
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

The plugin only loads when this file exists. `<C-n>` opens the notes panel.

---

## Updating

```vim
:Lazy update       " update all plugins
:Lazy sync         " install missing + update + clean unused
:TSUpdate          " update treesitter parsers
:Mason             " manage LSP servers / linters / formatters
```

After updating, commit `lazy-lock.json` to pin plugin versions across machines.

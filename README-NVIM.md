# Neovim Configuration

Config location: `~/.config/nvim/`

## File Structure

```
~/.config/nvim/
  init.lua              -- Entry point: sources .vimrc, bootstraps lazy.nvim, loads modules
  lua/
    base.lua            -- Core editor settings (indentation, search, encoding, etc.)
    plugins/
      init.lua          -- All plugin specs for lazy.nvim
```

## Plugin Manager

### lazy.nvim
Auto-bootstrapped on first launch. No manual install needed.

| Command | Description |
|---|---|
| `:Lazy` | Open the lazy.nvim dashboard |
| `:Lazy sync` | Install, update, and clean plugins |
| `:Lazy update` | Update all plugins |
| `:Lazy clean` | Remove unused plugins |
| `:Lazy health` | Check plugin health |

---

## Plugins

### UI & Icons

#### nvim-web-devicons
File type icons used by nvim-tree, lualine, bufferline, and telescope.

- Requires a [Nerd Font](https://www.nerdfonts.com/) installed and set in your terminal.

#### catppuccin (colorscheme)
Warm pastel color scheme. Set to `mocha` (dark) flavour.

| Command | Description |
|---|---|
| `:colorscheme catppuccin-mocha` | Dark variant |
| `:colorscheme catppuccin-latte` | Light variant |
| `:colorscheme catppuccin-frappe` | Medium-dark variant |
| `:colorscheme catppuccin-macchiato` | Darker variant |

#### lualine.nvim (statusline)
Configurable statusline at the bottom showing mode, file path, git branch, diagnostics, etc. Themed with catppuccin. No keybindings needed -- it's always visible. Displays the **relative file path** so you always know which file you're editing.

#### bufferline.nvim (buffer tabs)
Displays open buffers as tabs at the top of the editor.

| Key | Action |
|---|---|
| `Tab` | Next buffer |
| `Shift+Tab` | Previous buffer |
| `<leader>x` | Close current buffer |
| `<leader>X` | Close all other buffers |

---

### Navigation

#### telescope.nvim (fuzzy finder)
Powerful fuzzy finder for files, text, buffers, and more. Replaces fzf inside Neovim.

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search text across files) |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Search help tags |
| `<leader>fr` | Recent files |
| `<leader>fs` | Grep word under cursor |

Inside Telescope:
| Key | Action |
|---|---|
| `<C-n>` / `<C-p>` | Next / previous result |
| `<CR>` | Open selected |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<Esc>` | Close telescope |

#### nvim-tree.lua (file explorer)
Sidebar file tree explorer.

| Key | Action |
|---|---|
| `<leader>e` | Toggle file explorer |

Inside nvim-tree:
| Key | Action |
|---|---|
| `<CR>` or `o` | Open file/folder |
| `a` | Create new file/folder |
| `d` | Delete |
| `r` | Rename |
| `c` / `p` | Copy / paste |
| `x` | Cut |
| `R` | Refresh |
| `q` | Close tree |

---

### LSP & Completion

#### mason.nvim (LSP server installer)
Manages installation of LSP servers, formatters, and linters.

| Command | Description |
|---|---|
| `:Mason` | Open Mason dashboard |
| `:MasonInstall <server>` | Install a server (e.g., `rust_analyzer`) |
| `:MasonUninstall <server>` | Uninstall a server |
| `:MasonLog` | View install logs |

Pre-configured servers: `ts_ls` (TypeScript), `lua_ls` (Lua), `pyright` (Python).

#### nvim-lspconfig (LSP keybindings)
These keybindings are active in any buffer with an LSP server attached:

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>d` | Show diagnostics float |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>f` | Format file |

#### nvim-cmp (autocompletion)
Provides autocomplete suggestions as you type.

| Key | Action |
|---|---|
| `<C-Space>` | Trigger completion manually |
| `<CR>` | Confirm selected suggestion |
| `<Tab>` | Next suggestion / expand snippet |
| `<S-Tab>` | Previous suggestion |
| `<C-b>` / `<C-f>` | Scroll docs up / down |
| `<C-e>` | Dismiss completion menu |

Sources (in priority order): LSP, snippets, buffer words, file paths.

---

### Syntax & Editing

#### nvim-treesitter (syntax highlighting)
Modern, AST-based syntax highlighting. Far more accurate than regex-based highlighting.

| Command | Description |
|---|---|
| `:TSInstall <lang>` | Install parser for a language |
| `:TSUpdate` | Update all parsers |
| `:TSInstallInfo` | List installed parsers |

Pre-installed parsers: lua, javascript, typescript, tsx, python, json, html, css, markdown, bash, vim, vimdoc.

#### nvim-treesitter-textobjects (code navigation & selection)
Jump between and select functions, classes, and blocks using treesitter's understanding of code structure.

**Move between code blocks:**

| Key | Action |
|---|---|
| `]f` | Jump to next function start |
| `[f` | Jump to previous function start |
| `]F` | Jump to next function end |
| `[F` | Jump to previous function end |
| `]c` | Jump to next class start |
| `[c` | Jump to previous class start |

**Select code blocks (visual mode or with operators like `d`, `y`, `c`):**

| Key | Action | Example |
|---|---|---|
| `af` | Around function (includes signature) | `daf` deletes entire function |
| `if` | Inside function (body only) | `vif` selects function body |
| `ac` | Around class | `yac` yanks entire class |
| `ic` | Inside class | `vic` selects class body |
| `ab` | Around block (if/for/while) | `dab` deletes entire block |
| `ib` | Inside block | `vib` selects block body |

#### nvim-autopairs
Automatically closes brackets, quotes, and parentheses as you type. No keybindings -- works automatically in insert mode.

#### Comment.nvim
Toggle comments on lines or selections.

| Key | Action |
|---|---|
| `gcc` | Toggle comment on current line |
| `gc` (visual) | Toggle comment on selection |
| `gbc` | Toggle block comment on current line |
| `gcO` | Add comment on line above |
| `gco` | Add comment on line below |

#### nvim-surround
Add, change, or delete surrounding characters (quotes, brackets, tags, etc.).

| Key | Action | Example |
|---|---|---|
| `ys<motion><char>` | Add surrounding | `ysiw"` surrounds word with `"` |
| `cs<old><new>` | Change surrounding | `cs"'` changes `"hello"` to `'hello'` |
| `ds<char>` | Delete surrounding | `ds"` removes `"` from `"hello"` |
| `S<char>` (visual) | Surround selection | Select text, press `S"` |

---

### Git

#### gitsigns.nvim
Shows git diff markers in the sign column (left gutter). Inline blame is enabled by default.

| Key | Action |
|---|---|
| `<leader>gp` | Preview hunk (see the diff inline) |
| `<leader>gb` | Toggle inline git blame |

| Command | Description |
|---|---|
| `:Gitsigns stage_hunk` | Stage the current hunk |
| `:Gitsigns reset_hunk` | Reset the current hunk |
| `:Gitsigns diffthis` | Diff current file |

#### vim-fugitive
Full Git integration inside Neovim.

| Command | Description |
|---|---|
| `:Git` | Open git status (like `git status`) |
| `:Git blame` | Inline blame for the whole file |
| `:Git log` | View git log |
| `:Git diff` | View diff |
| `:Gvdiffsplit` | Side-by-side diff of current file |
| `:Git push` | Push to remote |
| `:Git pull` | Pull from remote |

---

## Leader Key

The leader key is set to **Space**. All `<leader>` keybindings above use Space as the prefix.

## Quick Reference: Most Used Keybindings

| Key | Action |
|---|---|
| `Space + ff` | Find files |
| `Space + fg` | Search text in project |
| `Space + e` | Toggle file tree |
| `gd` | Go to definition |
| `K` | Hover docs |
| `Space + ca` | Code action |
| `Space + rn` | Rename symbol |
| `gcc` | Toggle line comment |
| `Tab` / `S-Tab` | Next / prev buffer |
| `Space + x` | Close current buffer |
| `Space + X` | Close all other buffers |
| `]f` / `[f` | Next / prev function |
| `daf` / `dif` | Delete around / inside function |

## Requirements

- Neovim >= 0.11
- A [Nerd Font](https://www.nerdfonts.com/) for icons (e.g., JetBrainsMono Nerd Font)
- `git` for plugin installation
- `ripgrep` for Telescope live grep (`brew install ripgrep`)

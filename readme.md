# Neovim Configuration

A highly opinionated Neovim setup with essential plugins, sensible defaults, and out-of-the-box LSP / Treesitter support.

---

## 🚀 Features

- **Core configs**

  - `.luarc.json` for Lua language server
  - `.stylua.toml` for opinionated code formatting

- **Modular init.lua**

  - Loads `core/options.lua`, `core/keymaps.lua`, `core/snippets.lua`
  - Plugin management via lazy-loading and `lazy-lock.json`

- **Plugin highlights**

  - **Themes**: Nord, One Dark, Tokyo Night
  - **Autocompletion**: nvim-cmp, snippet support
  - **Navigation**: Telescope, Neo-Tree, Harpoon, Bufferline
  - **Git**: Gitsigns, Lazygit integration
  - **Debugging**: nvim-dap + UI
  - **LSP**: Built-in LSP configs with mason.nvim
  - **Treesitter**: Syntax, incremental selection, text objects
  - **Extras**: ChatGPT integration, aerial outline, indent guides, commentary, tmux navigator

- **Troubleshooting**
  - A dedicated `nvim-troubleshooting.md` guides you through common issues

---

## 📦 Installation

1. **Clone** this repo into your Neovim configuration directory:

   ```bash
   git clone https://github.com/Copxer/neovim.git ~/.config/nvim
   ```

2. **Install [Neovim 0.9+](https://github.com/neovim/neovim/releases).**

3. **Launch Neovim** to trigger plugin install:

   ```bash
   nvim
   ```

   - The first run will bootstrap `lazy.nvim` and install everything.

4. (Optional) **Run Stylua** against your Lua files:
   ```bash
   stylua .
   ```

---

## ⚙️ Configuration

All customization lives under `lua/`:

- `lua/core/options.lua` — basic Neovim settings
- `lua/core/keymaps.lua` — custom keybindings
- `lua/core/snippets.lua` — built-in LuaSnip snippets
- `lua/plugins/` — one file per plugin to keep things tidy

To add or tweak plugins, open or create a new file in `lua/plugins/` following the existing pattern.

---

## 📝 Usage

- **Jump to symbol outline**: `<leader>a` (Aerial)
- **Fuzzy file search**: `<leader>f` (Telescope)
- **Toggle file explorer**: `<leader>e` (Neo-Tree)
- **Git hunks**: `[c` / `]c`, use `:Gitsigns` commands
- **Debug**: open DAP UI with `<leader>d`

See `core/keymaps.lua` for a complete list of mappings.

---

## 🛠 Troubleshooting

Consult [nvim-troubleshooting.md](./nvim-troubleshooting.md) if you run into:

- Plugin install failures
- LSP or Treesitter errors
- Formatting issues with Stylua
- Missing binaries (e.g., `lua-language-server`, `mason` packages)

---

## 🎯 Contributing

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/foo`)
3. Commit your changes (`git commit -m "feat: add foo"`)
4. Push to the branch (`git push origin feature/foo`)
5. Open a Pull Request

---

## 🙌 Credits

Built with ❤️ and Lua in mind, inspired by the Neovim community.

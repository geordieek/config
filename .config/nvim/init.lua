if vim.g.vscode then
  -- VSCode Neovim settings
  require("vscode_settings.settings")
else
  -- bootstrap lazy.nvim, LazyVim and your plugins
  require("config.lazy")
end

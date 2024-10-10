# Config and dotfiles

- Tracked using a bare repo from [this guide](https://www.atlassian.com/git/tutorials/dotfiles).
- Special thanks to @typecraft-dev for a lot of inspiration with many parts of this setup.

### Relevant software

- nvim
- wezterm
- tmux
  - [tpm](https://github.com/tmux-plugins/tpm) manages plugins
- oh-my-zsh
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - [powerlevel10k](https://github.com/romkatv/powerlevel10k) (get fonts from here)
- lazyvim
  - fd
  - ripgrep
- lazygit
- fzf
- bat
- nerdfonts

#### TODO

- Write more custom aliases and include them in their own .md or in here.
- Write package manager script for easier package install on different systems.
- Investigate GNU Stow for managing this repo
- Move from `vim-test` to [neotest](https://github.com/nvim-neotest/neotest)
- Remap keyboard so held caps lock acts as ctrl

#### Things to investigate

- [diagflow.nvim](https://github.com/dgagn/diagflow.nvim) for showing diagnostics in top-right

#### Other misc info

- Wezterm requires MesloLGS fonts from powerlevel10k
- In Windows, Neovim files go in C:\Users\your_username\AppData\Local\nvim. Update settings.vim path in vim init.lua

# Config and dotfiles

- Tracked using a bare repo from [this guide](https://www.atlassian.com/git/tutorials/dotfiles).
- Special thanks to @typecraft-dev for a lot of inspiration with many parts of this setup.

### Included tools

- nvim
- wezterm
- tmux
  - [tpm](https://github.com/tmux-plugins/tpm) manages plugins
- oh-my-zsh
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - [powerlevel10k](https://github.com/romkatv/powerlevel10k) (get fonts from here)
- lazyvim
- lazygit
- fd
- ripgrep
- fzf
- bat
- nerdfonts
- tealdeer

#### Installation instructions
1. Run `dev-setup.sh` to install and configure tools
2. Pull this config repo, using this [bare repo guide](https://www.atlassian.com/git/tutorials/dotfiles)

#### TODO

- Write more custom aliases and include them in their own .md or in here.
- Fix install script so that it works across MacOS, Arch & Debian systems
- Investigate GNU Stow for managing this repo
- Move from `vim-test` to [neotest](https://github.com/nvim-neotest/neotest)
- Remap keyboard so held caps lock acts as ctrl (achieved in MacOS with karabiner elements, I should track this as part of config)

#### Things to investigate

- [diagflow.nvim](https://github.com/dgagn/diagflow.nvim) for showing diagnostics in top-right

#### Other misc info

- Wezterm requires MesloLGS fonts from powerlevel10k
- In Windows, Neovim files go in C:\Users\your_username\AppData\Local\nvim. Update settings.vim path in vim init.lua

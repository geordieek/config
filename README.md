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

#### Installation instructions
- Initialise config repo on new computer with instructions from bare repo guide
- Install necessary programs with brew using following script
<details>

<summary> Bash installation script </summary>

```bash
#!/bin/bash

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# List of programs to install via Homebrew
programs=("neovim" "tmux" "fzf" "bat" "lazygit" "fd" "ripgrep")

# Install the core programs possible with brew
for program in "${programs[@]}"; do
    if ! brew list "$program" &> /dev/null; then
        echo "Installing $program..."
        brew install "$program"
    else
        echo "$program is already installed."
    fi
done

# List of casks to install via Homebrew
programs=("wezterm")

# Install the core programs
for program in "${programs[@]}"; do
    if ! brew list "$program" &> /dev/null; then
        echo "Installing $program..."
        brew install --cask "$program"
    else
        echo "$program is already installed."
    fi
done


# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# Install zsh plugins: autosuggestions, syntax-highlighting, and powerlevel10k
ZSH_CUSTOM="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    <!-- git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" -->
    brew install zsh-autosuggestions
else
    echo "zsh-autosuggestions is already installed."
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    # git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    brew install zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting is already installed."
fi

# powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Installing powerlevel10k..."
    # git clone https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
    brew install powerlevel10k
else
    echo "powerlevel10k is already installed."
fi

# Install Tmux Plugin Manager (TPM) for tmux
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    echo "Tmux Plugin Manager (TPM) is already installed."
fi

# TODO: Install Nerd Fonts for powerlevel10k
echo "TODO: Include nerd font files and install them here."

# Prompt to apply changes
echo "All tools have been installed. Resourcing .zshrc"
source ~/.zshrc

# Install lazyvim and its dependencies

# Make a backup of current nvim setup
echo "Backing up current nvim setup"
# required backup
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

echo "Installing LazyVim setup..."
git clone https://github.com/LazyVim/starter ~/.config/nvim
nvim +LazyInstall +q
rm -rf ~/.config/nvim/.git

# Add config alias back, so can easily access config repo
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

echo "Automated installation complete! You will need to manually download and install the powerlevel10k nerd fonts."
```
</details>

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

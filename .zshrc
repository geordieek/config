# =============================================================================
# ~/.zshrc
# =============================================================================

# --- Cursor fast path --------------------------------------------------------
# Cursor injects COMPOSER_NO_INTERACTION=1. Detect it and bail early with only
# the essentials so Cursor's shell integration stays fast.
export CURSOR="false"
if [[ "$PAGER" == "head -n 10000 | cat" || "$COMPOSER_NO_INTERACTION" == "1" ]]; then
  export CURSOR="true"
fi

if [[ "$CURSOR" == "true" ]]; then
  export COREPACK_ENABLE_AUTO_PIN=0
  export EDITOR='nvim'
  export PATH="$HOME/.local/bin:$PATH"
  alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
  [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
  nvm() { unset -f nvm; [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"; nvm "$@"; }
  return
fi

# --- Powerlevel10k instant prompt --------------------------------------------
# Must come before any output. Prompts / [y/n] confirmations go above this.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Environment -------------------------------------------------------------
export COREPACK_ENABLE_AUTO_PIN=0
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"

# Prefer nvim; fall back to vim over SSH where nvim may not be available
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# --- Oh My Zsh ---------------------------------------------------------------
# On macOS, p10k is sourced directly from Homebrew (see Plugins section below).
# ZSH_THEME="" tells OMZ to skip theme loading so p10k isn't loaded twice.
if [[ "$(uname)" == "Darwin" ]]; then
  ZSH_THEME=""
  plugins=(git)
else
  ZSH_THEME="powerlevel10k/powerlevel10k"
  plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
fi

source "$ZSH/oh-my-zsh.sh"

# --- Plugins (macOS, Homebrew managed) ---------------------------------------
# On Linux, OMZ manages plugins via the plugins=() array above.
# The # [setup] markers below are used by dev-setup.sh for idempotency checks.
if [[ "$(uname)" == "Darwin" ]]; then
  source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"         # [setup] powerlevel10k
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"   # [setup] zsh-autosuggestions
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"  # [setup] zsh-syntax-highlighting — must be last
fi

# --- NVM (lazy load) ---------------------------------------------------------
# Deferring NVM init until first use saves ~300ms on shell startup.
# On Linktree machines, NVM itself is managed by the Linktree onboarding setup.
[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm
  case "$(uname -s)" in
    Linux)
      if [[ -d "/usr/share/nvm" ]]; then
        # Arch Linux
        source /usr/share/nvm/nvm.sh
        source /usr/share/nvm/bash_completion
        source /usr/share/nvm/install-nvm-exec
      else
        # Ubuntu / other distributions
        [[ -s "$NVM_DIR/nvm.sh" ]]          && source "$NVM_DIR/nvm.sh"
        [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
      fi
      ;;
    Darwin)
      [[ -s "$NVM_DIR/nvm.sh" ]]          && source "$NVM_DIR/nvm.sh"
      [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
      ;;
  esac
  nvm "$@"
}

# --- pnpm --------------------------------------------------------------------
if [[ "$(uname)" == "Darwin" ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi

# --- Google Cloud SDK --------------------------------------------------------
[[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]]       && source "$HOME/google-cloud-sdk/path.zsh.inc"
[[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]] && source "$HOME/google-cloud-sdk/completion.zsh.inc"

# --- fzf ---------------------------------------------------------------------
# [setup] fzf
if [[ "$(uname)" == "Darwin" ]]; then
  source <(fzf --zsh)
else
  # Linux: fzf installed manually, integration written to ~/.fzf.zsh
  [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
fi

# Directory search (alt-c): skip generated/vendor/system folders
export FZF_ALT_C_COMMAND="fd --type d --hidden \
  --exclude .git \
  --exclude node_modules \
  --exclude dist \
  --exclude build \
  --exclude coverage \
  --exclude __generated__ \
  --exclude 'Library/**' \
  --exclude 'Applications/**' \
  --exclude 'System/**' \
  --exclude 'usr/**' \
  --exclude 'var/**' \
  --exclude 'tmp/**' \
  --exclude 'Downloads/**' \
  --exclude 'Desktop/**' \
  --exclude 'Documents/Archive/**'"

# --- Aliases -----------------------------------------------------------------
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'  # [setup] dotfiles alias
alias lg='lazygit'                                                     # quick lazygit
alias inv='nvim $(fzf -m --preview="bat --color=always {}")'          # fzf picker → nvim

# --- Powerlevel10k config ----------------------------------------------------
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

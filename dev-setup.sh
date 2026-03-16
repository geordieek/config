#!/usr/bin/env bash

# =============================================================================
# Personal Dev Environment Setup
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------

log() { echo "[INFO]  $*"; }
warn() { echo "[WARN]  $*" >&2; }
die() {
  echo "[ERROR] $*" >&2
  exit 1
}

# Ensure we're on macOS
[[ "$(uname -s)" == "Darwin" ]] || die "This script is intended for macOS only."

# -----------------------------------------------------------------------------
# NVM
# -----------------------------------------------------------------------------

if ! nvm &>/dev/null; then
  log "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
else
  log "NVM already installed."
fi

# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------

if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add Homebrew to PATH immediately (required on Apple Silicon before next steps)
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  log "Homebrew already installed."
fi

# -----------------------------------------------------------------------------
# Homebrew formulae
# -----------------------------------------------------------------------------

BREW_FORMULAE=(
  neovim
  tmux
  fzf
  bat
  lazygit
  fd
  ripgrep
  tealdeer
  zsh-autosuggestions
  zsh-syntax-highlighting
  powerlevel10k
)

log "Installing Homebrew formulae..."
for formula in "${BREW_FORMULAE[@]}"; do
  if brew list --formula "$formula" &>/dev/null; then
    log "  $formula — already installed."
  else
    log "  Installing $formula..."
    brew install "$formula"
  fi
done

# fzf key bindings and fuzzy completion (non-interactive, zsh only)
log "Configuring fzf shell integration..."
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish

# Update tldr page cache
log "Updating tealdeer cache..."
tldr --update || warn "tealdeer cache update failed — run 'tldr --update' manually."

# -----------------------------------------------------------------------------
# Homebrew casks
# -----------------------------------------------------------------------------

BREW_CASKS=(
  wezterm
  karabiner-elements
)

log "Installing Homebrew casks..."
for cask in "${BREW_CASKS[@]}"; do
  if brew list --cask "$cask" &>/dev/null; then
    log "  $cask — already installed."
  else
    log "  Installing $cask..."
    brew install --cask "$cask"
  fi
done

# -----------------------------------------------------------------------------
# MesloLGS NF fonts (Powerlevel10k's custom font variant)
#
# NOTE: 'font-meslo-lg-nerd-font' from Homebrew installs the Nerd Fonts v3
# release, which renames the font family to "MesloLGS Nerd Font". Powerlevel10k
# ships its own pre-patched build under the name "MesloLGS NF" — this is what
# WezTerm configs referencing 'MesloLGS NF' expect. We install it directly from
# the p10k media repository to guarantee the correct family name.
# -----------------------------------------------------------------------------

FONT_DIR="$HOME/Library/Fonts"
P10K_FONT_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
P10K_FONTS=(
  "MesloLGS NF Regular.ttf"
  "MesloLGS NF Bold.ttf"
  "MesloLGS NF Italic.ttf"
  "MesloLGS NF Bold Italic.ttf"
)

log "Installing MesloLGS NF fonts for Powerlevel10k..."
mkdir -p "$FONT_DIR"
for font in "${P10K_FONTS[@]}"; do
  dest="$FONT_DIR/$font"
  if [[ -f "$dest" ]]; then
    log "  '$font' — already installed."
  else
    log "  Downloading '$font'..."
    encoded_font="${font// /%20}"
    curl -fsSL "$P10K_FONT_BASE/$encoded_font" -o "$dest"
  fi
done

# -----------------------------------------------------------------------------
# Karabiner-Elements configuration
#
# Caps Lock dual-role:
#   - Tap  → Escape  (great for Vim/Neovim)
#   - Hold → Left Control
#
# Uses Python (always available on macOS) to create or safely patch
# karabiner.json — preserves any existing profile settings and only inserts
# the rule if it isn't already present.
# -----------------------------------------------------------------------------

configure_karabiner() {
  local karabiner_dir="$HOME/.config/karabiner"
  local config_file="$karabiner_dir/karabiner.json"
  local mods_dir="$karabiner_dir/assets/complex_modifications"

  mkdir -p "$mods_dir"

  # Write the named complex-modification file (used by the Karabiner GUI)
  cat >"$mods_dir/caps_lock_dual_role.json" <<'EOF'
{
  "title": "Caps Lock → Escape / Control",
  "rules": [
    {
      "description": "Caps Lock → Escape (tap) / Left Control (hold)",
      "manipulators": [
        {
          "type": "basic",
          "from": {
            "key_code": "caps_lock",
            "modifiers": { "optional": ["any"] }
          },
          "to": [{ "key_code": "left_control", "lazy": true }],
          "to_if_alone": [{ "key_code": "escape" }]
        }
      ]
    }
  ]
}
EOF

  # Create or patch the main karabiner.json
  python3 - "$config_file" <<'PYEOF'
import json, sys, os

config_path = sys.argv[1]

NEW_RULE = {
    "description": "Caps Lock \u2192 Escape (tap) / Left Control (hold)",
    "manipulators": [
        {
            "type": "basic",
            "from": {
                "key_code": "caps_lock",
                "modifiers": {"optional": ["any"]}
            },
            "to": [{"key_code": "left_control", "lazy": True}],
            "to_if_alone": [{"key_code": "escape"}]
        }
    ]
}

DEFAULT_CONFIG = {
    "global": {
        "check_for_updates_on_startup": True,
        "show_in_menu_bar": True,
        "show_profile_name_in_menu_bar": False
    },
    "profiles": [
        {
            "name": "Default profile",
            "selected": True,
            "complex_modifications": {
                "parameters": {
                    "basic.simultaneous_threshold_milliseconds": 50,
                    "basic.to_delayed_action_delay_milliseconds": 500,
                    "basic.to_if_alone_timeout_milliseconds": 500,
                    "basic.to_if_held_down_threshold_milliseconds": 500
                },
                "rules": []
            },
            "devices": [],
            "fn_function_keys": [],
            "simple_modifications": [],
            "virtual_hid_keyboard": {
                "country_code": 0,
                "indicate_sticky_modifier_keys_state": True,
                "mouse_key_xy_scale": 100
            }
        }
    ]
}

if os.path.exists(config_path):
    with open(config_path) as f:
        config = json.load(f)
    print(f"  Patching existing {config_path}")
else:
    config = DEFAULT_CONFIG
    print(f"  Creating new {config_path}")

# Target the active (selected) profile, fall back to first
profile = next(
    (p for p in config["profiles"] if p.get("selected")),
    config["profiles"][0]
)

cm = profile.setdefault("complex_modifications", {"parameters": {}, "rules": []})
rules = cm.setdefault("rules", [])

if any(r.get("description") == NEW_RULE["description"] for r in rules):
    print("  Rule already present — skipping.")
else:
    rules.insert(0, NEW_RULE)
    os.makedirs(os.path.dirname(config_path), exist_ok=True)
    with open(config_path, "w") as f:
        json.dump(config, f, indent=2)
    print("  Rule added successfully.")
PYEOF
}

log "Configuring Karabiner-Elements (Caps Lock → Escape/Control)..."
configure_karabiner

# -----------------------------------------------------------------------------
# Oh My Zsh
# -----------------------------------------------------------------------------

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing Oh My Zsh (unattended — will not change default shell)..."
  # RUNZSH=no  → don't launch zsh at end of installer
  # CHSH=no    → don't chsh mid-script
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "Oh My Zsh already installed."
fi

# -----------------------------------------------------------------------------
# Tmux Plugin Manager (TPM)
# -----------------------------------------------------------------------------

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  log "Installing Tmux Plugin Manager..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  log "TPM already installed."
fi

# -----------------------------------------------------------------------------
# Neovim / LazyVim
# -----------------------------------------------------------------------------

backup_if_exists() {
  local path="$1"
  if [[ -e "$path" ]]; then
    local backup="${path}.bak.$(date +%Y%m%d_%H%M%S)"
    log "  Backing up $path → $backup"
    mv "$path" "$backup"
  fi
}

log "Setting up LazyVim..."
backup_if_exists "$HOME/.config/nvim"
backup_if_exists "$HOME/.local/share/nvim"
backup_if_exists "$HOME/.local/state/nvim"
backup_if_exists "$HOME/.cache/nvim"

git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
rm -rf "$HOME/.config/nvim/.git"

log "Running LazyVim initial plugin sync (headless — this may take a minute)..."
nvim --headless "+Lazy! sync" +qa

# -----------------------------------------------------------------------------
# .zshrc configuration
# Appends blocks guarded by unique markers — safe to re-run (idempotent).
# -----------------------------------------------------------------------------

ZSHRC="$HOME/.zshrc"

append_if_missing() {
  local marker="$1"
  local block="$2"
  if grep -qF "$marker" "$ZSHRC" 2>/dev/null; then
    log "  '$marker' already in .zshrc — skipping."
  else
    log "  Adding '$marker' to .zshrc..."
    printf '\n%s\n' "$block" >>"$ZSHRC"
  fi
}

# Powerlevel10k (installed via Homebrew, sourced directly)
append_if_missing "# [setup] powerlevel10k" \
  '# [setup] powerlevel10k
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme'

# zsh-autosuggestions
append_if_missing "# [setup] zsh-autosuggestions" \
  '# [setup] zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh'

# zsh-syntax-highlighting — must be sourced last among plugins
append_if_missing "# [setup] zsh-syntax-highlighting" \
  '# [setup] zsh-syntax-highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'

# fzf shell integration
append_if_missing "# [setup] fzf" \
  '# [setup] fzf
source <(fzf --zsh)'

# Dotfiles bare-repo alias (git --git-dir pattern for managing dotfiles)
append_if_missing "# [setup] dotfiles alias" \
  "# [setup] dotfiles alias
alias config='/usr/bin/git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME'"

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------

log ""
log "============================================================"
log "  Setup complete!"
log "============================================================"
log ""
log "Manual steps remaining:"
log "  1. Restart your terminal (or run: exec zsh)"
log "  2. Run 'p10k configure' to set up your Powerlevel10k prompt"
log "  3. In WezTerm settings, set the font to 'MesloLGS NF'"
log "     (installed directly from the Powerlevel10k media repo)"
log "  4. Start tmux and press <prefix>+I to install TPM plugins"
log "  5. Open Karabiner-Elements and grant Accessibility & Input"
log "     Monitoring permissions when prompted — required for key remapping"
log ""

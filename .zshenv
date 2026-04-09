export NVM_DIR="$HOME/.nvm"

# Add NVM's default node bin to PATH for all shell types (fast — just reads
# alias files, no NVM loading). Ensures node/npm/npx are found by /bin/sh
# hooks and any process that inherits PATH from the launching terminal.
if [[ -d "$NVM_DIR/versions/node" ]]; then
  _nvm_ver=$(cat "$NVM_DIR/alias/default" 2>/dev/null)
  # Resolve named alias file (e.g. default → lts/iron → v22.x.x)
  if [[ -f "$NVM_DIR/alias/$_nvm_ver" ]]; then
    _nvm_ver=$(cat "$NVM_DIR/alias/$_nvm_ver" 2>/dev/null)
  fi
  # Resolve lts/* or lts/name
  if [[ "$_nvm_ver" == lts/* ]]; then
    _lts="${_nvm_ver#lts/}"
    [[ "$_lts" == "*" ]] \
      && _nvm_ver=$(ls -1 "$NVM_DIR/alias/lts/" 2>/dev/null | xargs -I{} cat "$NVM_DIR/alias/lts/{}" 2>/dev/null | sort -V | tail -1) \
      || _nvm_ver=$(cat "$NVM_DIR/alias/lts/$_lts" 2>/dev/null)
    unset _lts
  fi
  # Resolve version prefix (e.g. "22" → latest installed v22.x.x)
  if [[ -n "$_nvm_ver" && "$_nvm_ver" != v* ]]; then
    _nvm_ver=$(ls -1d "$NVM_DIR/versions/node/v${_nvm_ver}."* 2>/dev/null | sort -V | tail -1)
    _nvm_ver="${_nvm_ver##*/}"
  fi
  [[ -d "$NVM_DIR/versions/node/$_nvm_ver/bin" ]] && \
    export PATH="$NVM_DIR/versions/node/$_nvm_ver/bin:$PATH"
  unset _nvm_ver
fi

# load_nvm lives here (not .zshrc) because Claude Code's shell snapshots
# capture the lazy stubs but filter out _-prefixed functions.
load_nvm() {
  unset -f nvm node npm npx yarn corepack ltd 2>/dev/null
  case "$(uname -s)" in
    Linux)
      if [[ -d "/usr/share/nvm" ]]; then
        source /usr/share/nvm/nvm.sh
        source /usr/share/nvm/bash_completion
        source /usr/share/nvm/install-nvm-exec
      else
        [[ -s "$NVM_DIR/nvm.sh" ]]          && source "$NVM_DIR/nvm.sh"
        [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
      fi
      ;;
    Darwin)
      [[ -s "$NVM_DIR/nvm.sh" ]]          && source "$NVM_DIR/nvm.sh"
      [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
      ;;
  esac
}

# Non-interactive shells don't source .zshrc so lazy stubs never run.
# Load NVM fully so the nvm command itself works.
if [[ ! -o interactive ]]; then
  load_nvm
fi

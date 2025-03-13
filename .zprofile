# Only on MacOS
if [[ "$(uname)" == "Darwin" ]]; then
  # Homebrew setup
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Added by `rbenv init` on Tue 18 Feb 2025 20:12:47 AEDT
eval "$(rbenv init - --no-rehash zsh)"

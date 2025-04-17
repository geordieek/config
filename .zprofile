# Only on MacOS
if [[ "$(uname)" == "Darwin" ]]; then
  # Homebrew setup
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

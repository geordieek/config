eval "$(/opt/homebrew/bin/brew shellenv)"

# Stop corepack from adding 'packageManager' to package.json
COREPACK_ENABLE_AUTO_PIN=0

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Environment

## Node.js via nvm

The `.zshrc` lazy-loads nvm via wrapper functions, which causes `FUNCNEST` recursion errors in non-interactive shells. Before running any node/npm/npx command, prefix with:

```bash
unset -f node npm npx nvm 2>/dev/null; export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh" &&
```

This clears the broken wrappers, sources nvm properly, and respects per-project `.nvmrc` files.

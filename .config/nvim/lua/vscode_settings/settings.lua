-- Navigate between editor panes
vim.api.nvim_set_keymap(
  "n",
  "<C-j>",
  [[:call VSCodeNotify('workbench.action.navigateDown')<CR>]],
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
  "x",
  "<C-j>",
  [[:call VSCodeNotify('workbench.action.navigateDown')<CR>]],
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-k>",
  [[:call VSCodeNotify('workbench.action.navigateUp')<CR>]],
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
  "x",
  "<C-k>",
  [[:call VSCodeNotify('workbench.action.navigateUp')<CR>]],
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-h>",
  [[:call VSCodeNotify('workbench.action.navigateLeft')<CR>]],
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
  "x",
  "<C-h>",
  [[:call VSCodeNotify('workbench.action.navigateLeft')<CR>]],
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-l>",
  [[:call VSCodeNotify('workbench.action.navigateRight')<CR>]],
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
  "x",
  "<C-l>",
  [[:call VSCodeNotify('workbench.action.navigateRight')<CR>]],
  { silent = true, noremap = true }
)

-- Toggle editor widths
vim.api.nvim_set_keymap(
  "n",
  "<C-w>_",
  [[:<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>]],
  { silent = true, noremap = true }
)

-- Which key
vim.api.nvim_set_keymap("n", "<Space>", [[:call VSCodeNotify('whichkey.show')<CR>]], { silent = true, noremap = true })
vim.api.nvim_set_keymap("x", "<Space>", [[:call VSCodeNotify('whichkey.show')<CR>]], { silent = true, noremap = true })

-- Tab navigation
vim.api.nvim_set_keymap(
  "n",
  "H",
  [[:call VSCodeNotify('workbench.action.previousEditor')<CR>]],
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
  "n",
  "L",
  [[:call VSCodeNotify('workbench.action.nextEditor')<CR>]],
  { silent = true, noremap = true }
)

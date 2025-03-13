-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here-- ~/.config/nvim/lua/options.lua (or wherever your options.lua is located)

-- Set wrapping by default
vim.opt.wrap = true

-- FIXME: Configure diagnostics properly
-- vim.diagnostic.config({
--   underline = true,
--   virtual_text = {
--     severity = vim.diagnostic.severity.WARN, -- Show for warnings and errors
--     source = "if_many", -- Show source if there are multiple
--     spacing = 4,
--     prefix = "●",
--     format = function(diagnostic)
--       return string.format("%s", diagnostic.message)
--     end,
--     virt_text_hide = true, -- Hide virtual text by default
--   },
--   signs = true, -- Show signs in the gutter
--   float = {
--     show_header = true,
--     border = "rounded",
--   },
--   update_in_insert = false,
--   severity_sort = true,
-- })

-- Show virtual text only when cursor is on the line
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = 0,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = " ",
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})

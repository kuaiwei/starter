-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- basic option and setting of neovim
local options = {
  background    = "light",
  backup        = false,
  clipboard     = "unnamedplus",          -- allows neovim to access the system clipboard
  hlsearch      = true,
  ignorecase    = true,
  mouse         = "",                     -- disable mouse by default, use <F2> to switch mouse support
  pumheight     = 10,                     -- popup menu height
  showtabline   = 2,                      -- always show tabs
  smartcase     = true,
  smartindent   = true,
  splitright    = true,
  splitbelow    = true,
  swapfile      = false,
  timeoutlen    = 300,                    -- time to wait for a mapped sequence to complete (in milliseconds)
  writebackup   = false,
  expandtab     = true,
  shiftwidth    = 2,
  tabstop       = 2,
  wrap          = true,
  linebreak     = true,
  scrolloff     = 8,                      -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,                      -- minimal number of screen columns either side of cursor if wrap is `false`
}

for k,v in pairs(options) do
  vim.opt[k] = v
end

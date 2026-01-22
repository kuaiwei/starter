-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opt = {
  noremap = true,
  silent = true,
}

local map = vim.api.nvim_set_keymap
-- move between windows
map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)

-- toggle mouse/fold support, it help copy text in terminal
local toggle_mouse_and_fold = function()
  if vim.opt.mouse._value == "a" then
    print("Disable mouse and fold")
    vim.opt.mouse = ""
    vim.opt.foldenable = false
  else
    print("Enable mouse and fold")
    vim.opt.mouse = "a"
    vim.opt.foldenable = true
  end
end

map("", "<F2>", "", {
  noremap = true,
  silent = true,
  callback = function()
    toggle_mouse_and_fold()
  end,
  desc = "toggle both mouse mode and fold (enable/disable)",
})

-- clear 'n', 'N' map set by layzvim, act as default
vim.keymap.del("n", "n")
vim.keymap.del("o", "n")
vim.keymap.del("x", "n")
vim.keymap.del("n", "N")
vim.keymap.del("o", "N")
vim.keymap.del("x", "N")

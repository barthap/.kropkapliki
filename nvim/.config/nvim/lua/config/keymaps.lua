-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Map leader Y  to copy to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Copy to system clipboard" })

-- ThePrimeagen keymap - use leader P to paste without losing the copy register
map("x", "<leader>p", '"_dP', { desc = "Paste (keep content)" })
map("n", "x", '"_x')

-- Motherfuckers deleted my favourite shortcut
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })
map({ "v" }, "g", "*N", { desc = "Search for selection" })

-- Duplicate line
map("n", "<C-A-j>", "yyp", { desc = "Duplicate line below" })
map("n", "<C-A-k>", "yyP", { desc = "Duplicate line above" })

-- Swap default explorer root
map("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "Explorer (cwd)" })

map("n", "<leader>E", function()
  Snacks.explorer({ cwd = LazyVim.root() })
end, { desc = "Explorer (root dir)" })

-- TODO: Swap terminal and others too? <leader>f<whatever>

-- Double space should be relative to cwd, not found root
map("n", "<leader><space>", function()
  Snacks.picker.smart()
end, { desc = "Find Files" })

-- Window resize - originals don't work on mac
map("n", "<C-A-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
-- map("n", "<C-A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- map("n", "<C-A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

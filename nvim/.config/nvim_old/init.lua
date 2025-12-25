-- these must be set before lazy.vim plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("barthap.plugins-setup")

require("barthap.config.options")
require("barthap.config.autocmds")
require("barthap.config.keymaps")

-- set up colorscheme
require("barthap.config").colorscheme()

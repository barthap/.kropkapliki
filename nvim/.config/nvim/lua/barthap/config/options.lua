local opt = vim.opt

-- line numbers
opt.number = true
opt.relativenumber = true

-- tabs and indents
opt.tabstop = 2 -- Number of spaces tabs count for
opt.shiftwidth = 2 -- Size of an indent
opt.expandtab = true -- Use spaces instead of tabs
opt.autoindent = true
opt.smartindent = true

-- line wrapping
opt.wrap = false -- Disable line wrap

-- search options
opt.ignorecase = true -- ignore case
opt.smartcase = true -- Don't ignore case with capitals

-- cursor line
opt.cursorline = true -- Enable highlighting of the current line

-- appearance
opt.termguicolors = true -- True color support
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.showmode = false -- Dont show mode (insert/normal etc) since we have a statusline
-- this one is disabled because it also hides code block markup
-- it can be toggled by <leader>uc
-- opt.conceallevel = 3 -- Hide * markup for bold and italic

-- below are copied from LazyVim
opt.autowrite = true -- Enable auto write
-- opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shortmess:append({ W = true, I = true, c = true })
opt.sidescrolloff = 8 -- Columns of context
opt.spelllang = { "en", "pl" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width

if vim.fn.has("nvim-0.9.0") == 1 then
	opt.splitkeep = "screen"
	opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

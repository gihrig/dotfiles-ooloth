-- default nvim options: https://neovim.io/doc/user/vim_diff.html#nvim-defaults

---------------
-- BEHAVIOUR --
---------------

-- editing
vim.opt.clipboard:append('unnamedplus') -- use the macos system clipboard when yanking, cutting or deleting
vim.opt.iskeyword:append('-') -- treat hyphens as part of a single word
vim.opt.undofile = true -- persist buffer undo tree after closing

-- searching
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- unless search includes uppercase letters

-- quitting
vim.opt.confirm = true -- offer to save changes to open files before :q

-- see: https://unix.stackexchange.com/a/383044
vim.cmd([[
" Trigger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
            \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
]])

----------------
-- APPEARANCE --
----------------

-- colors
vim.opt.termguicolors = true

-- cursor
vim.opt.cursorline = true
vim.cmd([[
  autocmd InsertEnter * set nocursorline
  autocmd InsertLeave * set cursorline
]])

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd([[
  " see: https://stackoverflow.com/a/10410590/8802485
  let ignored_filetypes = ['help', 'NvimTree', 'packer', 'qf', 'TelescopePrompt', 'Trouble']
  autocmd WinLeave * if index(ignored_filetypes, &ft) < 0 | setlocal norelativenumber | endif
  autocmd WinEnter * if index(ignored_filetypes, &ft) < 0 | setlocal relativenumber | endif
  autocmd InsertEnter * if index(ignored_filetypes, &ft) < 0 | setlocal norelativenumber | endif
  autocmd InsertLeave * if index(ignored_filetypes, &ft) < 0 | setlocal relativenumber | endif
]])

-- line wrapping
-- vim.opt.listchars:append('precedes:<,extends:>')
vim.opt.scrolloff = 20 -- min lines between cursor and top/bottom of window
-- vim.opt.sidescroll = 5
-- vim.opt.sidescrolloff = 5 -- min lines between cursor and left/right of window
vim.opt.wrap = false

-- spacing
vim.opt.cmdheight = 0
vim.opt.signcolumn = 'yes'

-- split windows
vim.opt.splitbelow = true
vim.opt.splitright = true

-- tabs & indentation
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftround = true -- round indent to multiple of 'shiftwidth'
vim.opt.shiftwidth = 2
vim.opt.smartindent = true -- auto-indent when starting a new line
vim.opt.tabstop = 2

vim.cmd([[
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 200})
]])

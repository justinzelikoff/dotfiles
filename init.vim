" ==============================================================================
" 1. General Settings
" ==============================================================================
set number              " Show line numbers
set termguicolors       " Enable 24-bit true colors
set ttimeout            " Speed up escape key responsiveness
set ttimeoutlen=50

" Press F12 to save and run current Python code
autocmd FileType python nnoremap <buffer> <F9> :w<CR>:!python3 %<CR>

" ==============================================================================
" 2. Plugin Management (vim-plug)
" ==============================================================================
call plug#begin('~/.local/share/nvim/plugged')

" Existing plugins
Plug 'tpope/vim-sensible'
Plug 'wojciechkepka/vim-github-dark'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }  " Native Neovim Lua theme
Plug 'sheerun/vim-polyglot'

" Neovim plugins for status bar & LSP support
Plug 'neovim/nvim-lspconfig'        " Presets for Neovim's built-in LSP client
Plug 'nvim-lualine/lualine.nvim'    " Sleek status bar
Plug 'nvim-tree/nvim-web-devicons'  " Devicons support for the status bar

call plug#end()

" ==============================================================================
" 3. Theme & Transparency Setup
" ==============================================================================
augroup TransparentBg
  autocmd!
  autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
        \ | highlight NormalNC guibg=NONE ctermbg=NONE
        \ | highlight SignColumn guibg=NONE ctermbg=NONE
        \ | highlight LineNr guibg=NONE ctermbg=NONE
        \ | highlight EndOfBuffer guibg=NONE ctermbg=NONE
augroup END

" ==============================================================================
" 4. Lua Setup (Theme, Statusline & Neovim 0.11+ Native LSP)
" ==============================================================================
lua << EOF
-- Configure Catppuccin Mocha theme
require('catppuccin').setup({
  flavour = "mocha",
})
vim.cmd.colorscheme("catppuccin")

-- Configure Lualine status bar
require('lualine').setup({
  options = {
    theme = 'catppuccin-mocha',
    icons_enabled = true,
  }
})

-- Improve auto-completion menu behavior
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Enable Python LSP (Pyright) using Neovim 0.11+ native loader
vim.lsp.enable('pyright')
EOF

" ==============================================================================
" 1. General Settings
" ==============================================================================
set number              " Show line numbers
set termguicolors       " Enable 24-bit true colors
set ttimeout            " Speed up escape key responsiveness
set ttimeoutlen=50

" Set space as leader key
let mapleader = " "

" Press F9 to save and run current Python code
autocmd FileType python nnoremap <buffer> <F9> :w<CR>:!python3 %<CR>

" Easy exit from Neovim terminal mode
tnoremap <Esc> <C-\><C-n>

" Allow Ctrl+w window navigation directly inside the terminal
tnoremap <C-w> <C-\><C-n><C-w>

" Pressing 'gl' opens the diagnostic error message floating window
nnoremap gl <cmd>lua vim.diagnostic.open_float()<CR>

" Keymap to toggle transparency: Space + t + t
nnoremap <leader>tt <cmd>lua ToggleTransparency()<CR>

" ==============================================================================
" 2. Plugin Management (vim-plug)
" ==============================================================================
call plug#begin('~/.local/share/nvim/plugged')

" Existing plugins
Plug 'tpope/vim-sensible'

" Themes & Modern Syntax Parsing
Plug 'navarasu/onedark.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Neovim plugins for status bar & LSP support
Plug 'neovim/nvim-lspconfig'        " Presets for Neovim's built-in LSP client
Plug 'nvim-lualine/lualine.nvim'    " Sleek status bar
Plug 'nvim-tree/nvim-web-devicons'  " Devicons support for the status bar
Plug 'jiangmiao/auto-pairs'         " Auto-close brackets, quotes, parens

" suda.vim gives sudo abilities
Plug 'lambdalisue/suda.vim'
let g:suda_smart_edit = 1

call plug#end()

" ==============================================================================
" 3. Theme Persistence
" ==============================================================================
let g:transparent_enabled = 1
let g:theme_state_file = stdpath('data') . '/last_colorscheme.txt'

function! SaveCurrentTheme()
  if exists('g:colors_name')
    call writefile([g:colors_name], g:theme_state_file)
  endif
endfunction

function! LoadSavedTheme()
  if filereadable(g:theme_state_file)
    let l:saved_theme = readfile(g:theme_state_file)[0]
    try
      execute 'colorscheme ' . l:saved_theme
    catch
      colorscheme onedark
    endtry
  else
    colorscheme onedark
  endif
endfunction

augroup RememberTheme
  autocmd!
  autocmd ColorScheme * call SaveCurrentTheme()
augroup END

augroup TreesitterHighlight
  autocmd!
  autocmd FileType * lua pcall(vim.treesitter.start)
augroup END

" ==============================================================================
" 4. Lua Setup (Theme, Treesitter, Statusline & LSP)
" ==============================================================================
lua << EOF
-- The brute-force toggle function
function _G.ToggleTransparency()
  local is_trans = not (vim.g.transparent_enabled == 1)
  vim.g.transparent_enabled = is_trans and 1 or 0
  
  require("onedark").setup({
    style = 'dark',
    transparent = is_trans,
    lualine = {
        transparent = is_trans,
    },
  })
  require("onedark").load()
  
  -- THE KITTY BYPASS: Force the background to an offset hex code so it paints solid
  if not is_trans then
    vim.cmd("hi Normal guibg=#282c35 ctermbg=235")
    vim.cmd("hi NormalNC guibg=#282c35 ctermbg=235")
    vim.cmd("hi EndOfBuffer guibg=#282c35 ctermbg=235")
    vim.cmd("hi SignColumn guibg=#282c35 ctermbg=235")
  end
  
  print("Transparency " .. (is_trans and "ON" or "OFF"))
end

-- Initial Setup based on saved state
local is_trans = (vim.g.transparent_enabled == 1)

local ok_onedark, onedark = pcall(require, "onedark")
if ok_onedark then
  onedark.setup({
    style = 'dark',
    transparent = is_trans,
    lualine = {
        transparent = is_trans,
    },
  })
end

-- Restore last used theme automatically on startup
vim.cmd('call LoadSavedTheme()')

-- Apply the Kitty bypass on startup if transparency is off (Must run AFTER LoadSavedTheme)
if not is_trans then
  vim.cmd("hi Normal guibg=#282c35 ctermbg=235")
  vim.cmd("hi NormalNC guibg=#282c35 ctermbg=235")
  vim.cmd("hi EndOfBuffer guibg=#282c35 ctermbg=235")
  vim.cmd("hi SignColumn guibg=#282c35 ctermbg=235")
end

-- Configure Treesitter
local ok_ts, ts = pcall(require, "nvim-treesitter.configs")
if ok_ts then
  ts.setup({
    ensure_installed = { 
      "rust", "python", "lua", "vim", "vimdoc", 
      "bash", "json", "html", "css", "javascript", 
      "typescript", "markdown", "markdown_inline", "yaml" 
    },
    auto_install = true,
    highlight = { enable = true, additional_vim_regex_highlighting = false },
  })
end

-- Configure Lualine
local ok_lualine, lualine = pcall(require, "lualine")
if ok_lualine then
  lualine.setup({ options = { theme = 'auto', icons_enabled = true } })
end

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.lsp.enable('pyright')
vim.lsp.enable('rust_analyzer')
EOF

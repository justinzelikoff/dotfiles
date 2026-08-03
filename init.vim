" ==============================================================================
" 1. General Settings
" ==============================================================================
set number              " Show line numbers
set termguicolors       " Enable 24-bit true colors
set ttimeout            " Speed up escape key responsiveness
set ttimeoutlen=50

" Press F9 to save and run current Python code
autocmd FileType python nnoremap <buffer> <F9> :w<CR>:!python3 %<CR>

" Easy exit from Neovim terminal mode
tnoremap <Esc> <C-\><C-n>

" Allow Ctrl+w window navigation directly inside the terminal
tnoremap <C-w> <C-\><C-n><C-w>

" Pressing 'gl' opens the diagnostic error message floating window
nnoremap gl <cmd>lua vim.diagnostic.open_float()<CR>

" Quick keymap to toggle background transparency (<tt>)
nnoremap <tt> :ToggleTransparent<CR>

" ==============================================================================
" 2. Plugin Management (vim-plug)
" ==============================================================================
call plug#begin('~/.local/share/nvim/plugged')

" Existing plugins
Plug 'tpope/vim-sensible'

" Themes & Modern Syntax Parsing
Plug 'olimorris/onedarkpro.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
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
" 3. Theme, Persistent Theme Choice & Toggleable Transparency
" ==============================================================================
let g:transparent_enabled = 1
let g:theme_state_file = stdpath('data') . '/last_colorscheme.txt'

" Function to save the current colorscheme whenever you change it
function! SaveCurrentTheme()
  if exists('g:colors_name')
    call writefile([g:colors_name], g:theme_state_file)
  endif
endfunction

" Function to load the saved theme on startup
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

function! ToggleTransparency()
  if g:transparent_enabled
    let g:transparent_enabled = 0
    let l:curr_theme = get(g:, 'colors_name', 'onedark')
    execute 'colorscheme ' . l:curr_theme
    echo "Transparency OFF"
  else
    let g:transparent_enabled = 1
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NormalNC guibg=NONE ctermbg=NONE
    highlight SignColumn guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
    echo "Transparency ON"
  endif
endfunction

" Command to easily toggle transparency on demand (:ToggleTransparent)
command! ToggleTransparent call ToggleTransparency()

" Save colorscheme automatically whenever you change it
augroup RememberTheme
  autocmd!
  autocmd ColorScheme * call SaveCurrentTheme()
augroup END

" Ensure transparency stays applied on colorscheme updates if enabled
augroup TransparentBg
  autocmd!
  autocmd ColorScheme * if g:transparent_enabled | 
        \ highlight Normal guibg=NONE ctermbg=NONE |
        \ highlight NormalNC guibg=NONE ctermbg=NONE |
        \ highlight SignColumn guibg=NONE ctermbg=NONE |
        \ highlight LineNr guibg=NONE ctermbg=NONE |
        \ highlight EndOfBuffer guibg=NONE ctermbg=NONE |
        \ endif
augroup END

" Automatically trigger Tree-sitter on any filetype that has a parser installed
augroup TreesitterHighlight
  autocmd!
  autocmd FileType * lua pcall(vim.treesitter.start)
augroup END

" ==============================================================================
" 4. Lua Setup (Theme, Treesitter, Statusline & LSP)
" ==============================================================================
lua << EOF
-- 1. Configure OneDarkPro Theme
local ok_onedark, onedark = pcall(require, "onedarkpro")
if ok_onedark then
  onedark.setup({
    styles = {
      comments = "italic",
      keywords = "bold,italic",
    },
  })
end

-- 2. Configure Catppuccin Theme
local ok_catppuccin, catppuccin = pcall(require, "catppuccin")
if ok_catppuccin then
  catppuccin.setup({
    flavour = "mocha",
  })
end

-- Restore your last used theme automatically on startup
vim.cmd('call LoadSavedTheme()')

-- 3. Configure Treesitter (safely guarded with auto-install)
local ok_ts, ts = pcall(require, "nvim-treesitter.configs")
if ok_ts then
  ts.setup({
    ensure_installed = { 
      "rust", "python", "lua", "vim", "vimdoc", 
      "bash", "json", "html", "css", "javascript", 
      "typescript", "markdown", "markdown_inline", "yaml" 
    },
    
    -- Auto-installs missing parsers automatically when opening new filetypes!
    auto_install = true,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  })
end

-- 4. Configure Lualine status bar (safely guarded)
local ok_lualine, lualine = pcall(require, "lualine")
if ok_lualine then
  lualine.setup({
    options = {
      theme = 'auto', -- Automatically matches active theme
      icons_enabled = true,
    }
  })
end

-- Improve auto-completion menu behavior
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Enable Python & Rust LSP using Neovim native loader
vim.lsp.enable('pyright')
vim.lsp.enable('rust_analyzer')
EOF

" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Go Plugin
Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.vim/plugged/gocode/nvim/symlink.sh' }

" deoplete autocomplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" Markdown plugin
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

" Directory Tree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Syntax
Plug 'sheerun/vim-polyglot'
Plug 'matthewbdaly/vim-filetype-settings'

 " Themes
Plug 'kristijanhusak/vim-hybrid-material'

" Initialize plugin system
call plug#end()

"General
syntax on
set number
set background=dark
colorscheme hybrid_material
filetype plugin indent on

"Code folding
set foldmethod=manual

"Tabs and spacing
set autoindent
set cindent
set tabstop=4
set expandtab
set shiftwidth=4
set smarttab
set nocompatible " Always set in nvim
filetype off

" Load plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'scrooloose/nerdtree'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'

Plugin 'ntpeters/vim-better-whitespace'

call vundle#end()
filetype plugin indent on

" General settings
set cpoptions+=d
set backspace=indent,eol,start
set ruler
set number
set relativenumber
set showcmd
set incsearch
set nohlsearch

set tabstop=4 " Tab characters appear 4 spaces wide
set softtabstop=0 noexpandtab " Always insert tabs when the tab key is pressed
set shiftwidth=4 " Indents are the same width as tabs

set ttimeout
set ttimeoutlen=100
set display=truncate
set scrolloff=5

set nrformats-=octal

" Search subdirs from cwd
set path=**

" Keep directories clean
set nobackup
set noundofile

syntax on

set mouse=a

hi clear SignColumn

set background=dark
colorscheme solarized

" Airline config
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_detect_paste = 1

let g:airline#extension#tabline#enabled = 1

let g:airline_theme = 'solarized'

" Tags config
let g:easytags_file = '~/.vim/tags'
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
set tags=./.tags;,~/.vim/tags
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1
let g:easytags_auto_highlight = 0

" Tagbar config
nmap <silent> <leader>b :TagbarToggle<CR>

" Better whitespace config
let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 1


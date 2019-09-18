set nocompatible " Always set in nvim
filetype off

" Load plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'junegunn/fzf.vim'

Plugin 'dart-lang/dart-vim-plugin'
Plugin 'fatih/vim-go'
Plugin 'leafgarland/typescript-vim'

Plugin 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }

Plugin 'tpope/vim-dispatch'

Plugin 'altercation/vim-colors-solarized'

Plugin 'ntpeters/vim-better-whitespace'

Plugin 'rbong/vim-crystalline'

call vundle#end()
filetype plugin indent on

" Do not suppress errors
" set shortmess-=F

" General settings
set ruler
set number
set relativenumber
set showcmd
set incsearch
set nohlsearch

set tabstop=4 " Tab characters appear 4 spaces wide
set softtabstop=-1 " Use shiftwidth spaces when converting tabs to spaces
set noexpandtab " Always insert tabs when the tab key is pressed
set shiftwidth=0 " Indents are the same width as tabs

set ttimeout
set ttimeoutlen=100
set display=truncate
set scrolloff=5

set nrformats-=octal

" Search subdirs from cwd
set path=.,,**

set hidden
" Keep directories clean
set nobackup
set noundofile

syntax on

runtime macros/matchit.vim

set mouse=a

set background=dark
colorscheme solarized

" Pretty statusline and tabline
function! StatusLine(...)
	return crystalline#mode() . '%#Crystalline# %<%f%h%w%m%r %#CrystallineFill# %=%#Crystalline# %y %c%V %P(%L) '
endfunction

function! TabLine()
	let l:vimlabel = has('nvim') ? ' NVIM ' : ' VIM '
	return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'solarized'

set showtabline=2
set guioptions-=e
set laststatus=2

" Render whitespace as
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" Custom tab label
set guitablabel=%{exists('t:mytablabel')?t:mytablabel\ :''}

let mapleader = "\<SPACE>"

augroup cusft
	autocmd!
	autocmd BufNewFile,BufRead *.glsl set filetype=glsl
augroup END

augroup cussyn
	autocmd!
	autocmd FileType glsl set syntax=c
augroup END

augroup setfmt
	autocmd!
	autocmd FileType dart set formatprg=dartfmt
	autocmd FileType cpp set formatprg=clang-format
	autocmd FileType go set formatprg=go\ fmt
augroup END

" Language client
let g:LanguageClient_serverCommands = {
	\ 'cpp' : ['clangd'],
	\ 'javascript' : ['javascript-typescript-stdio'],
	\ 'typescript' : ['javascript-typescript-stdio'],
	\ 'dart' : ['dart', '/opt/dart-sdk-dev/bin/snapshots/analysis_server.dart.snapshot', '--lsp'],
	\ 'go' : ['gopls'],
	\ }

let g:LanguageClient_rootMarkers = {
	\ 'javascript': ['jsconfig.json'],
	\ 'typescript': ['tsconfig.json'],
	\}

" Better whitespace config
let g:better_whitespace_enabled = 1
let g:strip_max_file_size = 0
let g:strip_whitespace_confirm = 0
let g:strip_whitespace_on_save = 1
let g:show_spaces_that_precede_tabs = 1

" Fzf config
let g:fzf_command_prefix = 'Fzf'

" Go config
let g:go_code_completion_enabled = 0 " Were using language client instead
let g:go_fmt_fail_silently = 1 " We can already see syntax errors, don't tell us again when formating

" C/C++ related binds
nnoremap <Leader>h :find %:t:r.h<CR>
nnoremap <Leader>c :find %:t:r.c<CR>
nnoremap <Leader>x :find %:t:r.cpp<CR>

" Build/run related binds
nnoremap <Leader>r :Make<CR>
nnoremap <Leader>R :execute "Make"<CR>:execute "Dispatch" g:prog<CR>

" Format with format prg
nnoremap <Leader>p mggggqG'g

" Language Client
nnoremap <Leader>ld :call LanguageClient#textDocument_definition()<CR>
nnoremap <Leader>li :call LanguageClient#textDocument_implementation()<CR>
nnoremap <Leader>lh :call LanguageClient#textDocument_hover()<CR>
nnoremap <Leader>lr :call LanguageClient#textDocument_rename()<CR>
nnoremap <Leader>l :call LanguageClient_contextMenu()<CR>

" FZF binds
nnoremap <Leader>ff :FzfFiles<CR>
nnoremap <Leader>fb :FzfBuffers<CR>
nnoremap <Leader>fl :FzfBLines<CR>
nnoremap <Leader>fL :FzfLines<CR>
nnoremap <Leader>fc :FzfCommands<CR>
nnoremap <Leader>fr :FzfRg<CR>


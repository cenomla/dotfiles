set nocompatible " Always set in nvim
filetype off

" Load plugins
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.fzf
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'junegunn/fzf.vim'

Plugin 'dart-lang/dart-vim-plugin'
Plugin 'fatih/vim-go'
Plugin 'ziglang/zig.vim'
Plugin 'leafgarland/typescript-vim'

Plugin 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }

Plugin 'tpope/vim-dispatch'

Plugin 'altercation/vim-colors-solarized'
Plugin 'morhetz/gruvbox'

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

set linebreak " Don't split up words on soft wrap

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

" Theme settings
set termguicolors
set background=dark
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_contrast_light = 'medium'
let g:gruvbox_improved_strings = 1
colorscheme gruvbox

" Use the default background for matched parenthesis
highlight MatchParen ctermbg=8

" Pretty statusline and tabline
function! StatusLine(current, width)
	let l:line = ''

	if a:current
		let l:line .= crystalline#mode() . '%#Crystalline#'
	else
		let l:line .= '%#CrystallineInactive#'
	endif
	let l:line .= ' %<%f%h%w%m%r '
	if a:current
		let l:line .= '%#CrystallineFill#'
	endif

	let l:line .= '%='

	if a:current
		let l:line .= '%= %{&paste ? "PASTE ":""}%{&spell?"SPELL ":""}%#Crystalline#'
	endif
	if a:width > 80
		let l:line .= ' %{&ft} | %{&fenc!=#""?&fenc:&enc} | %{&ff} %c%V %P(%L)'
	endif
	let l:line .= ' '


	return l:line
endfunction

function! TabLine()
	let l:vimlabel = has('nvim') ? ' NVIM ' : ' VIM '
	return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'gruvbox'

set laststatus=2
set signcolumn=no

" Render whitespace as
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

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
	autocmd FileType dart set formatprg=dart\ format\ -l\ 120
	autocmd FileType cpp set formatprg=clang-format
	autocmd FileType go set formatprg=go\ fmt
augroup END

augroup cusmake
	autocmd!
	autocmd FileType typescript set makeprg=tsc
	autocmd FileType markdown set makeprg=markdown\ -f\ fencedcode\ -S\ -o\ /tmp/out.html\ %
	autocmd QuickFixCmdPost [^l]* nested cwindow
	autocmd QuickFixCmdPost   l* nested lwindow
augroup END

augroup cusindent
	autocmd!
	autocmd FileType dart setlocal tabstop=2 softtabstop=-1 expandtab shiftwidth=0
augroup END

" Language client
let g:LanguageClient_serverCommands = {
	\ 'cpp' : ['clangd'],
	\ 'javascript' : ['javascript-typescript-stdio'],
	\ 'typescript' : ['javascript-typescript-stdio'],
	\ 'dart' : ['dart', 'language-server'],
	\ 'go' : ['gopls'],
	\ }

let g:LanguageClient_rootMarkers = {
	\ 'javascript': ['jsconfig.json'],
	\ 'typescript': ['tsconfig.json'],
	\ 'cpp': ['compile_commands.json', 'build/compile_commands.json', 'build-ninja/compile_commands.json'],
	\}

let g:LanguageClient_applyCompletionAdditionalTextEdits = 0 " Don't edit things I don't want you too
let g:LanguageClient_diagnosticsList = 'Location'
let g:LanguageClient_diagnosticsDisplay = {
	\	1: {
	\		'name': 'Error',
	\		'texthl': 'None',
	\		'signText': 'None',
	\		'signTexthl': 'None',
	\		'virtualTexthl': 'Error',
	\	},
	\	2: {
	\		'name': 'Warning',
	\		'texthl': 'None',
	\		'signText': 'None',
	\		'signTexthl': 'None',
	\		'virtualTexthl': 'Todo',
	\	},
	\	3: {
	\		'name': 'Information',
	\		'texthl': 'None',
	\		'signText': 'None',
	\		'signTexthl': 'None',
	\		'virtualTexthl': 'Todo',
	\	},
	\	4: {
	\		'name': 'Hint',
	\		'texthl': 'None',
	\		'signText': 'None',
	\		'signTexthl': 'None',
	\		'virtualTexthl': 'Todo',
	\	},
	\}

" Better whitespace config
let g:better_whitespace_enabled = 1
let g:strip_max_file_size = 0
let g:strip_whitespace_confirm = 0
let g:strip_whitespace_on_save = 1
let g:show_spaces_that_precede_tabs = 1

" Typescript config
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''

" Fzf config
let g:fzf_command_prefix = 'Fzf'
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden .'

" Go config
let g:go_code_completion_enabled = 0 " Were using language client instead
let g:go_fmt_fail_silently = 1 " We can already see syntax errors, don't tell us again when formating

" File switch vars
let b:file_switch_regex = '^$'

function! BuildExtensionRegex(extensions)
	let l:regex = ''
	for ext in a:extensions
		if l:regex != ''
			let l:regex .= '\|'
		endif
		let l:regex .= '\(\.' . ext . '$\)'
	endfor
	return l:regex
endfunction

augroup file_switch_set_regex
	au FileType cpp let b:file_switch_regex = BuildExtensionRegex(['h', 'hpp', 'hh', 'hxx', 'c', 'cpp', 'cxx', 'cc'])
	au FileType c let b:file_switch_regex = BuildExtensionRegex(['h', 'c'])
augroup END

function! FindSimilarFile(name, regex)
	let l:files = globpath(&path, a:name . '.*', 0, 1)
	let l:matchFiles = []
	let l:currentFile = expand('%')
	let l:mi = -1

	for it in reverse(l:files)
		if it =~ a:regex
			if l:currentFile == it
				let l:mi = len(l:matchFiles)
			endif
			let l:matchFiles += [it]
		endif
	endfor

	" echo a:regex
	echo l:matchFiles

	if l:mi != -1
		execute 'e ' . l:matchFiles[(l:mi + 1) % len(l:matchFiles)]
	endif
endfunction

inoremap jk <ESC>
inoremap kj <ESC>

" C/C++ related binds
nnoremap <Leader>k :call FindSimilarFile(expand('%:t:r'), b:file_switch_regex)<CR>

" Build/run related binds
nnoremap <Leader>r :Make<CR>
nnoremap <Leader>R :execute "Make"<CR>:execute "Dispatch" g:prog<CR>

" Format with format prg
" mg - set mark g to cursor
" gg - move to first line
" gqG - format to last line
" 'g - move back to mark
nnoremap <Leader>p mggggqG'g

" Key bind for showing all project todos
nnoremap <Leader>t :cexpr system('rg -n TODO')<CR>

" Language Client
nnoremap <Leader>ld :call LanguageClient#textDocument_definition()<CR>
nnoremap <Leader>li :call LanguageClient#textDocument_implementation()<CR>
nnoremap <Leader>lh :call LanguageClient#textDocument_hover()<CR>
nnoremap <Leader>ln :call LanguageClient#textDocument_rename()<CR>
nnoremap <Leader>lr :call LanguageClient#textDocument_references()<CR>
nnoremap <Leader>ls :call LanguageClient#textDocument_signatureHelp()<CR>
nnoremap <Leader>l :call LanguageClient_contextMenu()<CR>

" FZF binds
nnoremap <Leader>ff :FzfFiles<CR>
nnoremap <Leader>fb :FzfBuffers<CR>
nnoremap <Leader>fl :FzfBLines<CR>
nnoremap <Leader>fL :FzfLines<CR>
nnoremap <Leader>fc :FzfCommands<CR>
nnoremap <Leader>fr :FzfRg<CR>


" Make your tabs equal to two spaces
set shiftwidth=2
set expandtab
set tabstop=2
set softtabstop=2

" If any literal tabs make their way into your files, highlight them
syn match tab display "\t"
hi link tab Error

" Highlight lines over 80 characters
match ErrorMsg '\%>80v.\+'

" Use :w!! to save with sudo
cmap w!! %!sudo tee > /dev/null %

" Highlight search results
set hlsearch
set showmatch

" Center view on search results
map n nzz
map N Nzz

" Sets up indenting
set autoindent
set smartindent
set smarttab

" Configure backspace
set bs=indent,eol,start

" Don't create backups
set nobackup

" Sets smart case search. Only searches case sensitively if there is a capital
" letter in your 
set ignorecase
set smartcase

" Line numbering
set number
set ruler

" Status line
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2

" Improve scrolling when lines wrap around
nnoremap <silent> k gk
nnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

" Swap ; and : outside of insert mode
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" Easier switching between splits
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-h> <C-w>h
map <C-Down> <C-w>j
map <C-Up> <C-w>k
map <C-Right> <C-w>l
map <C-Left> <C-w>h

" Don't emit bell noises/flashes
set noerrorbells
set visualbell t_vb=

set shell=bash

" Syntax highlighting
syntax on

" When you create a new file, fills in some code for you
" au BufNewFile *.h 0r ~/.vim/skeleton.h
" au BufNewFile *.cc 0r ~/.vim/skeleton.cc

" When you write a file, make sure no lines end in whitespace
autocmd BufWritePre *.cc :%s/\s\+$//e
autocmd BufWritePre *.h :%s/\s\+$//e


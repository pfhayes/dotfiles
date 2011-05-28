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

" Highligh search results
set hlsearch
set showmatch

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


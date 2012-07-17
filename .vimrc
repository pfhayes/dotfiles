syntax on

" plugins
filetype off
call pathogen#infect()
filetype plugin indent on

" Some reasonable defaults
set modelines=0
set hidden
set nocompatible
set shell=zsh
set noerrorbells
set visualbell t_vb=
set nobackup
set encoding=utf-8
set showmode
set showcmd
set ttyfast
set laststatus=2
set history=1000
set ignorecase
set smartcase
set incsearch
set gdefault
set lazyredraw
set splitbelow
set splitright
set title
set backspace=indent,eol,start
set number
set ruler
set autoindent
set smartindent
set smarttab
set shiftwidth=2
set expandtab
set tabstop=2
set softtabstop=2
set hlsearch
set gdefault
set scrolloff=3
set sidescroll=1
set sidescrolloff=10
set virtualedit=block,onemore
set wildmenu
set wildmode=longest,list:longest

let mapleader=","

" Turn off help
inoremap <F1> <ESC>
vnoremap <F1> <ESC>
nnoremap <F1> <ESC>

" Fixing delay sometimes when using O
set noesckeys

" Be bold
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

" NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Trying to use completion
set complete=.,b,u,]
imap <Leader><Tab> <C-P>
inoremap <C-Tab> <C-X> <C-L>

" Ctrl-P plugin
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Handles lines that are too big for the screen
let &showbreak = '> '
set cpo=n

" Turn off swap files
set noswapfile
set nobackup
set nowb

" set backupdir=~/.vim/tmp/backup//
" set directory=~/.vim/tmp/swap//
if version >= 703
  set undofile
  set undoreload=10000
  set undodir=~/.vim/tmp/undo//
endif

" When you type a # character as the first character of a line,
" it pushes that to the first column. This fixes that issue
inoremap # X<BS>#

" If any literal tabs make their way into your files, highlight them
syn match tab display "\t"
hi link tab Error

" Highlight lines over 80 characters
match ErrorMsg '\%>80v.\+'

" Highlight conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Use :w!! to save with sudo
cmap w!! %!sudo tee > /dev/null %

" Center view on search results
map n nzz
map N Nzz

" Clear search patterns after hitting enter
nnoremap <CR> :noh<CR><CR>
" Clear search patterns when entering insert mode
nnoremap i :noh<CR>i
nnoremap I :noh<CR>I
nnoremap a :noh<CR>a
nnoremap A :noh<CR>A
nnoremap o :noh<CR>o
nnoremap O :noh<CR>O
nnoremap s :noh<CR>s
nnoremap S :noh<CR>S
nnoremap R :noh<CR>R

" Status line
set statusline=%F%m%r%h%w\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

" When the window is resized, fix splits
au VimResized * exe "normal! \<c-w>="

" Improve scrolling when lines wrap around
nnoremap <silent> k gk
nnoremap <silent> j gj
" nnoremap <silent> <Up> gk
" nnoremap <silent> <Down> gj
" inoremap <silent> <Up> <Esc>gka
" inoremap <silent> <Down> <Esc>gja

" Better regex search
nnoremap / /\\v
vnoremap / /\\v

" Swap ; and : outside of insert mode
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" Press w to word wrap a block
vnoremap w gq

" Easier switching between splits
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-h> <C-w>h 
map <C-Down> <C-w>j
map <C-Up> <C-w>k
map <C-Right> <C-w>l
map <C-Left> <C-w>h

" Splits the current line at current position
nnoremap K h/[^ ]<cr>"zd$jyyP^v$h"zp:noh<cr>

" Better MatchParen
:hi MatchParen cterm=bold ctermbg=none ctermfg=white

" Use gw to open webpages. Only works in OS X right now
function! Website ()
  let s:url = expand("<cWORD>")
  let s:protocol = matchstr(s:url, '[a-z]*:\/\/')
  if s:protocol == ""
    let s:url = 'http://' . s:url
  endif
  exec "!open \"" . s:url . "\""
endfunction
nnoremap gw :call Website()<CR><CR>

" When you create a new file, fills in some code for you
au BufNewFile *.cc 0r ~/.vim/skeletons/skeleton.cc
au BufNewFile *.h 0r ~/.vim/skeletons/skeleton.h
au BufNewFile *.py 0r ~/.vim/skeletons/skeleton.py
au BufNewFile *.tex 0r ~/.vim/skeletons/skeleton.tex

" When you write a file, make sure no lines end in whitespace
autocmd BufWritePre *.cc :%s/\s\+$//e
autocmd BufWritePre *.h :%s/\s\+$//e
autocmd BufWritePre *.py :%s/\s\+$//e

" For writing text
au BufNewFile,BufRead *.txt setf txt
au FileType txt set tw=79

" Latex
au BufNewFile,BufRead *.tex setf tex
au FileType tex set tw=79

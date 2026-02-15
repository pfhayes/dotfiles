" plugins
if ! empty(globpath(&rtp, 'autoload/plug.vim'))
  call plug#begin()
  Plug 'dense-analysis/ale'
  Plug 'doums/darcula'
  Plug 'preservim/nerdcommenter'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-surround'
  Plug 'neovim/nvim-lspconfig'
  Plug '~/.vim/bundle/command-t'
  Plug 'windwp/nvim-autopairs'
  " Plug 'nvim-lualine/lualine.nvim'  " Icons broken, cant disable
  Plug 'vim-airline/vim-airline'  " Slow?  Try lualine instead?
  Plug 'luochen1990/rainbow'  " Slow?
  Plug 'TabbyML/vim-tabby'
  call plug#end()

  let g:rainbow_active = 1
  colo darcula

  " CommandT setup
  if has("nvim")
    nnoremap <silent> <c-p> :CommandTGit<CR>
    let g:CommandTPreferredImplementation='lua'
    let g:CommandTWildIgnore=''
    let g:CommandTMaxFiles = 40000
  elseif has("ruby")
    nnoremap <silent> <c-p> :CommandT<CR>
    let g:CommandTMaxFiles = 40000
    let g:CommandTUseGitLsFiles = 1
    let g:CommandTFileScanner = 'git'
    let g:CommandTMaxHeight = 10
    let g:CommandTWildIgnore = ''
  endif
endif

" Some reasonable defaults
set cursorline
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
set endofline
set tags=tags;

let mapleader=","

" Remove intro
set shortmess+=I

" Turn off help
inoremap <F1> <ESC>
vnoremap <F1> <ESC>
nnoremap <F1> <ESC>

" Highlight current line
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" jk to esc
inoremap jk <Esc>
cnoremap jk <C-c>

" Fixing delay sometimes when using O
" set noesckeys

" Region expand
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Jump to end after paste
vnoremap <silent> y y`]^
vnoremap <silent> p p`]^
nnoremap <silent> p p`]^

" stop dumb history window
map q: :q

" Automatically `set paste` when pasting text on OS X
imap <D-v> ^O:set paste<Enter>^R+^O:set nopaste<Enter>

" keystroke to toggle paste
nmap <silent> <leader>p :set paste!<CR>

" Handles lines that are too big for the screen
" let &showbreak = '> '
set cpo=n

" Turn off swap files
set noswapfile
set nobackup
set nowb

if version >= 703 && !has('nvim')
  set undofile
  set undoreload=10000
  set undodir=~/.vimtmp/tmp/undo//
endif

" When you type a # character as the first character of a line,
" it pushes that to the first column. This fixes that issue
inoremap # X<BS>#

" If any literal tabs make their way into your files, highlight them
highlight LiteralTabs ctermbg=darkcyan guibg=darkcyan
match LiteralTabs /\t\+/
au FileType python autocmd BufWinEnter * match LiteralTabs /\t\+/
au FileType python autocmd InsertEnter * match LiteralTabs /\t\+\%#\@<!/
au FileType python autocmd InsertLeave * match LiteralTabs /\t\+/
au FileType python autocmd BufWinLeave * call clearmatches()


" Highlight lines over 80 characters
match ErrorMsg '\%>80v.\+'

" Highlight conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Don't highlight the sign column (it looks terrible in dark displays)
highlight clear SignColumn

" Use :w!! to save with sudo
cmap w!! %!sudo tee > /dev/null %

" Center view on search results
map n nzz
map N Nzz

" Clear search patterns after hitting enter/space
nnoremap <CR> :noh<CR><CR>
nnoremap <space> :noh<CR><space>

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

" When the window is resized, fix splits
au VimResized * exe "normal! \<c-w>="

" Improve scrolling when lines wrap around
" nnoremap <silent> k gk
" nnoremap <silent> j gj
" nnoremap <silent> <Up> gk
" nnoremap <silent> <Down> gj
" inoremap <silent> <Up> <Esc>gka
" inoremap <silent> <Down> <Esc>gja

" Swap ; and : outside of insert mode
nnoremap ; :
" nnoremap : ;
vnoremap ; :
" vnoremap : ;

" Press w to word wrap a block
vnoremap w gq

" I hate when u lowercases text in visual mode
" Also I want to comment/uncomment blocks of code
vnoremap u ,ci

" Easier switching between splits
map <C-Down> <C-w>j
map <C-Up> <C-w>k
map <C-Right> <C-w>l
map <C-Left> <C-w>h

" Scroll up/down with C-j, C-k instead of C-u, C-d
noremap <C-j> <C-d>
noremap <C-k> <C-u>

" Buffers
nnoremap <C-e> :b#<CR>
nnoremap <C-i> :bprev<CR>
nnoremap <C-o> :bnext<CR>
nnoremap <C-n> :bd<CR>

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

" Copy current file path to buffer
nnoremap <Leader>f :let @+=expand('%:f')<CR>

" Keep files fresh
:au WinEnter * checktime
:au CursorHold * checktime
set updatetime=1000

" Yank to OSX keyboard with ,y
vmap <Leader>y "*y
nmap <Leader>y "*Y

" Scala stuff
" Indent function signatures. Gross
nmap <Leader>. ?def\\\\|class<CR>/(<CR>v/[:)]<CR>;<BS><BS><BS><BS><BS>s/\\%V\(\\_[ \\r]*/(\\r/<CR>vi(;s/,\\_[ \\r]*/,\\r/<CR>vi(10<vi(2>?(<CR>%i<CR><Esc><CR>

"function! QuitPrompt()
    "write
    "SyntasticCheck
    "if exists('b:syntastic_loclist') && !empty(b:syntastic_loclist) && b:syntastic_loclist.isEmpty()
        "quit
    "endif
"endfunction
"cabbrev wq :call QuitPrompt()<CR>

nmap <Leader>a [%
nmap <Leader>s ]%

au BufNewFile,BufRead BUILD setf python

" For code
set tw=119

" For text
au BufNewFile,BufRead *.txt setf txt
au FileType txt set tw=79
au BufNewFile,BufRead *.md setf md
au FileType md set tw=119
au BufNewFile,BufRead *.tex setf tex
au FileType tex set tw=79

noh

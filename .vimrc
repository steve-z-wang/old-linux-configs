"   ~/.vimrc  
"   written by Steve Wang

" Setting {{{

" basic 
set notimeout
set t_Co=256                    " 256 colors 
set background=dark             " Dark Background 

syntax enable                   " highlight syntax 
set nocompatible                " no Vi-compatible
set mouse=a                     " enable mouse
set ttymouse=urxvt              " terminal type 
set backspace=indent,eol,start  " enable backspace

set clipboard+=unnamed          " Use clipboard register '*' by default
set splitright                  " Split to right when `:vsp`
set splitbelow                  " Split to below when `:sp`
set scrolloff=5                 " 
set diffopt+=vertical
set wildmenu

" Folder
set foldmethod=syntax           " Fold based on marker
set nofoldenable                " Do not fold by default

" Visual
set title                       " Show window title
set number                      " Show line numbers
set nocursorline                " Highlight current line
set laststatus=2                " Always show status bar
set noshowmode
set showcmd

" Indent
set autoindent
set expandtab                   " Convert tabs to spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Search
set incsearch
set ignorecase
" Don't highlight when reloading vimrc
if !&hlsearch | set hlsearch | endif

" column ruler
set textwidth=72
set nowrap
set colorcolumn=+1

" Language
set fileencodings=utf-8,gbk
set termencoding=utf-8
set encoding=utf-8

" }}}
" Keymaps, Commands {{{

" Use `:help index` to see the default key bindings

let mapleader = ','

nnoremap <silent> q :confirm q<CR>

" Clear search highlight
nnoremap <silent> <BS> :nohlsearch<CR>

" If autocompletion popup visable, use <Tab> to select next item
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR>    pumvisible() ? "\<C-y>" : "\<CR>"

" }}}
" Plugins {{{

" Plug
call plug#begin()
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }  " nerdtree
Plug 'Shougo/neocomplete.vim'                           " neocomplete
Plug 'vim-syntastic/syntastic'                          " syntastic
Plug 'majutsushi/tagbar'                                " tagbar
Plug 'easymotion/vim-easymotion'                        " easymotion 
Plug 'vim-airline/vim-airline'                          " airline
Plug 'vim-airline/vim-airline-themes'                   " airline themes
Plug 'tpope/vim-surround'                               " surround
Plug 'kien/ctrlp.vim'                                   " ctrlp
Plug 'Yggdroot/indentLine'
Plug 'nanotech/jellybeans.vim'
call plug#end()

" Colorscheme
colorscheme jellybeans 

" Nerdtree
let NERDTreeShowHidden = 1
let NERDTreeWinSize = 30
map <C-n> :NERDTreeToggle<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Tagbar
nmap <F8> :TagbarToggle<CR>
let g:tagbar_ctags_bin = '/bin/ctags'
let g:tagbar_width = 30
let g:tagbar_sort = 0

" Airline
let g:airline_theme = 'jellybeans'
let g:airline#extensions#tabline#enabled = 0

" IndentLine 
let g:indentLine_enabled = 1
let g:indentLine_char = '┆'
let g:indentLine_first_char = '┆'
let g:indentLine_leadingSpaceEnabled = 1 
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_setColors=1
" }}}

" vim: foldmethod=marker

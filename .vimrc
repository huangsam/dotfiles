" => General
set history=500

" => VIM user interface
set number
set mouse=a
set hlsearch
set lazyredraw
set clipboard+=unnamedplus
set so=7
set wildmenu
set ruler
set cmdheight=1
set ignorecase
set smartcase
set magic
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" => Colors and Fonts
syntax enable
set encoding=utf8
set ffs=unix,dos,mac

" => Files, backups and undo
set nobackup
set nowb
set noswapfile

" => Text, tab and indent related
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set linebreak
set tw=500
set autoindent
set smartindent
set wrap

" => Moving around, tabs, windows and buffers
nnoremap <space> /
nnoremap <C-space> ?
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

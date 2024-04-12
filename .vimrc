" => General
set history=500

" => VIM user interface
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
set regexpengine=0
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
set lbr
set tw=500
set ai
set si
set wrap

" => Moving around, tabs, windows and buffers
map <space> /
map <C-space> ?
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

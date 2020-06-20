" General "{{{
set nocompatible          " diasable vi compatibility

scriptencoding utf-8      " use utf-8 encoding
set encoding=utf-8

set viminfo+=n~/.cache/.viminfo

set history=256           " number of things to remember in history
set autowrite             " writes on make/shell commands
set autoread

" Enable copy/paste directly to clipboard
set clipboard=unnamed

" Backup - write backup and immediately delete after save
set writebackup
set nobackup
set noswapfile            " disable swap file

" Match and search
set hlsearch              " highlight search
set ignorecase            " do case insensitive matching with
set smartcase             " be case sensitive when there is a capital letter 
set incsearch             " enable incremental search
" "}}}

" Formatting "{{{
set nowrap
set textwidth=0           " do not wrap lines by default
set backspace=indent      " more powerful backspacing
set backspace+=eol
set backspace+=start
set tabstop=2             " set the default tabstop to two spaces
set softtabstop=2         " set the default shift width for indents to two spaces
set expandtab             " make tabs into spaces
set smarttab              " smarter tab levels

set autoindent
set cindent
" "}}}

" Visual "{{{
syntax on                 " enable syntax highlighting
set mouse=a               " enable mouse in GUI mode
set mousehide             " hide mouse after chars typed
set relativenumber        " use relative line numbers
set showmatch             " show matching brackets
set matchtime=2           " bracket blinking

set wildmode=longest,list " at command line, completel longest common string, then list alternatives
set novisualbell          " no blinking
set noerrorbells          " no noise
set laststatus=2          " always show status line
set ruler                 " show the ruler
set foldenable            " turn on folding
set foldmethod=marker     " fold on the marker
set foldlevel=100         " dont autofold anything

set splitright
set splitbelow

" set list                  " display unprintable characters F12 - switches
set listchars=tab:\ .,eol:¬
set listchars+=trail:.
set listchars+=extends:»,precedes:«
map <silent> <F12> :set invlist<CR>
" "}}}

" Commands and Autocommands " {{{
" if editing a commit file, automatically enter insert mode
au! BufReadPost {COMMIT_EDITMSG,*/COMMIT_EDITMSG} setlocal ft=gitcommit noml list| norm 1G
au BufNewFile,BufRead gitcommit :1 | :start!

" Automatically move cursor to next line after 72 characters
autocmd FileType gitcommit set textwidth=72

" Highlight 51st character line (limit subject line to 50 characters)
autocmd FileType gitcommit set colorcolumn+=51

" automatically strip trailing whitespace from code on write
autocmd Filetype cpp,python,cmake autocmd BufWritePre <buffer> :%s/\s\+$//e

" indentation
autocmd FileType c,cpp,proto,java,javascript,css setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
" "}}}

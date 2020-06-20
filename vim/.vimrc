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

syntax on                 " enable syntax highlighting
set mouse=a               " enable mouse in GUI mode
set mousehide             " hide mouse after chars typed
set relativenumber        " use relative line numbers
set showmatch             " show matching brackets
set matchtime=2           " bracket blinking

set wildmode=longest,list " at command line, completel longest common string, then list alternatives
set novisualbell          " no blinking
set noerrorbells          " no noise
set belloff=all
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

" remember last line position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-commentary'
Plugin 'Valloric/YouCompleteMe'
Plugin 'dense-analysis/ale'
Plugin 'ctrlpvim/ctrlp.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let g:ale_linters={
\ 'python': ['ruff', 'mypy'],
\}
let g:ale_echo_msg_format = '%linter%: %s'

" setting it globally
let g:ale_fixers = {
\ 'python': ['ruff'],
\ }
let g:ale_fix_on_save = 1
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_open_list = 1

nnoremap <SPACE> <Nop>
let mapleader=" "

let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/global_extra_conf.py'
let g:ycm_auto_hover = ''
let g:ycm_python_binary_path = 'python'

nmap <leader>f <Plug>(YCMFindSymbolInWorkspace)
nnoremap <leader>g :YcmCompleter GoTo<CR>

let g:ctrlp_show_hidden = 1
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_mruf_relative=1

autocmd! BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~ "commit" |
\   exe "normal g`\"" |
\ endif

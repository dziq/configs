"Options

set number          
set autoindent
filetype plugin on
filetype on
colorscheme macvim
set spelllang=pl
syntax on 
set pastetoggle=<F11>
set fileencodings=utf-8,latin2
set hlsearch
set linebreak
set showmatch
set matchtime=2
set modeline
set modelines=4
set wildmenu
set showcmd
set nobackup
set nowritebackup
set textwidth=120
set nocompatible
set ruler
set smarttab
set title
set incsearch
set t_Co=256
filetype plugin indent on

"--{{{ Keybindings
"noremap <silent> <F11> :cal VimCommanderToggle()<CR>
"-- tabs
nmap    <C-t>          :tabnew<CR>
nmap    <C-c>          :tabclose<CR>
map     <C-left>       :tabprev<CR>
map     <C-right>      :tabnext<CR>
"-- insert current date
inoremap     <F2>      <C-R>=strftime("%Y-%m-%d %k:%M%z")<CR>
"-- spell checking
map     <silent><F7>   :setlocal spell!<CR> 
map     <F5>           :set spelllang=pl<CR>
map     <F6>           :set spelllang=en<CR>
map     <silent><F8>   :setlocal spell!<CR> 
map     <F12>          :TOhtml<CR>
map     <F3>           :NERDTreeToggle<CR><Esc>
"--}}}

" Snipmate setup
source ~/.vim/snippets/support_functions.vim
autocmd vimenter * call ExtractSnips("~/.vim/snippets/html", "eruby")
autocmd vimenter * call ExtractSnips("~/.vim/snippets/html", "php")


" Vim-LaTeX setup
filetype plugin on
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

autocmd BufNewFile,BufRead *PKGBUILD set filetype=sh
autocmd BufNewFile *PKGBUILD        0r ~/.vim/templates/PKGBUILD
autocmd BufNewFile *.sh            0r ~/.vim/templates/sh
autocmd BufNewFile *.py            0r ~/.vim/templates/python
autocmd BufNewFile *.pl            0r ~/.vim/templates/perl
autocmd BufRead,BufNewFile *.mkd,*.md,*.markdown   set filetype=mkd
autocmd FileType xhtml,xml,html so ~/.vim/ftplugin/html_autoclosetag.vim
autocmd BufNewFile,BufRead *.py set makeprg=python\ %  
autocmd BufNewFile,BufRead *.py source ~/.vim/autoload/pythoncomplete.vim

"--{{{ Highlighting, file templates and so on
autocmd BufNewFile,BufRead *PKGBUILD set filetype=sh
autocmd BufNewFile *PKGBUILD        0r ~/.vim/templates/PKGBUILD
autocmd BufNewFile *.sh            0r ~/.vim/templates/sh
autocmd BufNewFile *.py            0r ~/.vim/templates/python
autocmd BufNewFile *.pl            0r ~/.vim/templates/perl
autocmd BufRead,BufNewFile *.mkd,*.md,*.markdown   set filetype=mkd
autocmd FileType xhtml,xml,html so ~/.vim/ftplugin/html_autoclosetag.vim
autocmd BufNewFile,BufRead *conkyrc,*conkyrc* set filetype=conkyrc
autocmd BufWritePost *.sh,*.pl,*.cgi,*.py if FileExecutable("%:p") | :!chmod a+x % ^@ endif
autocmd BufWritePost .vimrc source %
autocmd BufNewFile * startinsert
autocmd BufNewFile,BufRead *.py set makeprg=python\ %  
autocmd BufNewFile,BufRead *.py source ~/.vim/autoload/pythoncomplete.vim
"--}}}

"--{{{ Options
set number          
set autoindent
filetype plugin on
filetype on
filetype indent on
tab all
colorscheme darkocean
set guifont=monospace\ 8
set spelllang=pl
set background=dark
set history=1000
syntax on    
set smarttab
set autoread
set tabstop=4
set shiftwidth=4
set expandtab
set pastetoggle=<F11>
set nocompatible
set ruler
set enc=utf-8
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
"set cursorline
set title

"-- Set 256 colors mode for xterm
if (&term == 'xterm')
        set t_Co=256
endif
"--}}}

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

"-- This function'll tell You if the file is executable
function! FileExecutable (fname)
      execute "silent! ! test -x" a:fname
      return v:shell_error
endfunction


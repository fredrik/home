packloadall

" for git commit messages, start in insert mode at end of first line
" (it might be possible to achieve the same result 
" with "export GIT_EDITOR='vim +startinsert!'")
" au FileType gitcommit execute "normal! A" | startinsert

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set noswapfile 

" set omnifunc=syntaxcomplete#Complete " via https://medium.com/vim-drops/javascript-autocompletion-on-vim-4fea7f6934e2

set backspace=indent,eol,start

" remove trailing whitespace
" https://vim.fandom.com/wiki/Remove_unwanted_spaces has more options
autocmd BufWritePre *.js %s/\s\+$//e

" open file relative to current file's directory
map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
map ,t :tabe <C-R>=expand("%:p:h") . "/" <CR>
map ,s :split <C-R>=expand("%:p:h") . "/" <CR>

" plug
call plug#begin('~/.vim/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdtree'
"Plug 'ternjs/tern_for_vim', {'do': 'npm install'}
"Plug 'junegunn/vim-easy-align'
"Plug 'https://github.com/junegunn/vim-github-dashboard.git'
"Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
call plug#end()




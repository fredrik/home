syntax on

" Use 2 spaces instead of tabs
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Backspace won't work without 'start' here.
set backspace=indent,eol,start

" Disable q: which would open up the command line.
" I often mistype this when quitting.
:nnoremap q: <Nop>

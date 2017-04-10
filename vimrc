" Autoreload vimrc
autocmd! bufwritepost .vimrc source %

" Easy to turn on paste mode
set pastetoggle=<F2>


" Deal with searching
set hlsearch
set incsearch
set ignorecase

" Remove highlight of last search
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>


" Toggle Line Numbers
noremap <F3> :set nu!<CR>

set et
set ts=2
set sw=2
set nu
set ai

set tw=79
set colorcolumn=80
highlight ColorColumn ctermbg=233

syntax on

"""""""""""""""""""""""""""""""""""""""
"" Vim Plug
"" https://github.com/junegunn/vim-plug
"---------------------------------------

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'

call plug#end()

let g:airline_theme='powerlineish'

"" Commands to run after
" PlugInstall
" PlugClean
" PlugUpdate

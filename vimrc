" Easy to turn on paste mode
set pastetoggle=<F2>


" Show whitespace
set list
set listchars=tab:>·,trail:·,extends:>,precedes:< ",space:␣,eol:¬,


" Split shortcuts
noremap <C-d> :split<CR>
noremap <C-s-d> :vsplit<CR>


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


" Editor settings
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

"" Commands to run after adding new plugins
" PlugInstall
" PlugClean
" PlugUpdate


"" Setup plugins

" Airline
set laststatus=2
let g:airline_theme='powerlineish'


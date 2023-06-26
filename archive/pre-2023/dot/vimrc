" Get access to bash commands
set shellcmdflag=-ic

" Easy to turn on paste mode
set pastetoggle=<F2>

" Show whitespace
set list
set listchars=tab:>·,trail:·,extends:>,precedes:< ",space:␣,eol:¬,


" Split shortcuts
noremap <C-d> :split<CR>


" Deal with searching
set hlsearch
set incsearch
" set ignorecase


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

set colorcolumn=80
highlight ColorColumn ctermbg=233


" Add tab settings
nnoremap th  :tabprev<CR>
nnoremap tl  :tabnext<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tt  <C-W>T
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>

" Set ejs as html syntax
filetype on
au BufNewFile,BufRead *.ejs set filetype=html

syntax on

"""""""""""""""""""""""""""""""""""""""
"" Vim Plug
"" https://github.com/junegunn/vim-plug
"---------------------------------------

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'octref/RootIgnore'
Plug 'https://github.com/ctrlpvim/ctrlp.vim'

Plug 'scrooloose/nerdtree'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'
Plug 'Shougo/vimproc'

call plug#end()

"" Commands to run after adding new plugins
" PlugInstall
" PlugClean
" PlugUpdate


""" Setup plugins

"" Airline
set laststatus=2
let g:airline_theme='powerlineish'

"----------

"" CtrlP

" Ignore gitignore files
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Add mapping commands
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

"----------

"" NERDTree

" Close vim if only NERDTree is left
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Open NERDTree if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree if in a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Toggle NERDTree, Highlighting our current file
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! TamNERDTreeToggle()
  if IsNERDTreeOpen()
    exe "NERDTreeClose"
  else
    exe "NERDTreeFind"
  endif
endfunction

noremap <C-\> :call TamNERDTreeToggle()<CR>

" Turn Off Old FileManager
let loaded_netrwPlugin=1

"----------

" Use RootIgnore to ignore dirs in NERDTree
let NERDTreeRespectWildIgnore=1

"----------

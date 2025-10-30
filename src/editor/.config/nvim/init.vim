" Base level vim settings
set title
set number
set expandtab
set scrolloff=8
set smartindent
set shiftwidth=4
set relativenumber
set tabstop=4 softtabstop=4
set titlestring=%{fnamemodify(getcwd(),':~:.')}
let mapleader = " "

" Plugin management via Plug
" TODO: telescope? what does this mean for fzf?
" TODO: preservim/tagbar? we'd want shortcuts to toggle it
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neanias/everforest-nvim', { 'branch': 'main' }
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
call plug#end()

" Theme 
colorscheme everforest
let g:airline_theme='papercolor'

" Window management
nnoremap <leader>ph :Ex<CR>
nnoremap <leader>pv :Vex<CR>

" Reload nvim configuration
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>

" Project navigration via NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" File based searching via fzf
" NOTE: ripgrep must be installed
nnoremap <leader>pg :GFiles<CR>
nnoremap <leader>pf :Files<CR>

" Git workflow
" TODO: figure this out
" NOTE: i'm thinkin <leader>gc for git commit kind of workflow

" Utility - Line go down, Line go up
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Utility - Yank to system clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

" Utility - Next and previous navigation in QuickFix List
nnoremap <C-k> :cnext<CR>
nnoremap <C-j> :cprev<CR>

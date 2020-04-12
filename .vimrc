set nocompatible              " be iMproved, required
filetype off                  " required

set backspace=indent,eol,start

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

Plugin 'vim-scripts/a.vim'
Plugin 'jansenm/vim-cmake'
Plugin 'preservim/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'

call vundle#end()
filetype plugin indent on

set encoding=utf-8

set exrc
set secure

setl tw=100

" Always use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab

set hidden

set ruler

syntax on
set hlsearch

" Fuzzy search
set path+=**
set wildmenu

set complete-=i

" Trim trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Use silver searcher for searching
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

" Insert templates
nnoremap ,doxyf :-1read $HOME/.vim/templates/DoxyHeader.txt<CR>jA <C-R>%<Esc>jjA <C-R>=strftime('%m/%d/%y')<CR><Esc>3j$

" NERDTree
map <C-n> :NERDTreeToggle<CR>
" Close vim if only NERDTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


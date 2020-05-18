" Vundle plugin manager
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
Plugin 'jceb/vim-orgmode'
Plugin 'majutsushi/tagbar'

call vundle#end()
filetype plugin indent on
" End Vundle plugin manager

set encoding=utf-8

set exrc
set secure

setl tw=100

" Always use spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab

" keep non-visible buffers open in background
set hidden

set ruler

syntax on
colorscheme noctu

set hlsearch

" Fuzzy search
set path+=**
set wildmenu

" do not search includes for autocomplete
set complete-=i

" C/C++ indentation
set cindent
set cinoptions=g-1

" Trim trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Grepping
" Use ag instead of regular grep
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m
" Run grepprg silently
function! Grep(...)
	return system(join([&grepprg] + [join(a:000, ' ')], ' '))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)
" replace grep by Grep
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

" automatically open quickfix window after populating it
augroup quickfix
	autocmd!
	autocmd QuickFixCmdPost cgetexpr cwindow
	autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

" Insert templates
nnoremap ,doxyf :-1read $HOME/.vim/templates/DoxyHeader.txt<CR>jA <C-R>=expand('%:t')<CR><Esc>jjA <C-R>=strftime('%m/%d/%y')<CR><Esc>3j$

" Easy escaping
inoremap jk <esc>
inoremap kj <esc>

" NERDTree
map <C-n> :NERDTreeToggle<CR>
map <F7> :NERDTreeFind<CR>
" Close vim if only NERDTree is open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Tagbar
map <F8> :TagbarToggle<CR>


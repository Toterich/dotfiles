" Disable python2 support
let g:loaded_python_provider = 0

" set the route of the executable
let g:python3_host_prog = '/usr/bin/python3'

" Explicitly tells to neovim to use python3 when evaluating python code
set pyxversion=3

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ${HOME}/.vimrc

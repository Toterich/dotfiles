# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Use vi-mode in shell prompt
set -o vi
# Use nvim/vim/vi as default editor
if [ -x "$(command -v nvim)" ];
then
   VISUAL=nvim
elif [ -x "$(command -v vim)" ];
then
   VISUAL=vim
else
   VISUAL=vi
fi

# Ignore/erase duplicate history entries, ignore commands starting with space
HISTCONTROL=ignoreboth:erasedups
# append history entries..
shopt -s histappend
# After each command, save and reload history
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
# Set max number of stored history lines in a session
HISTSIZE=1000
# Set max numbe of stored history lines in the history file
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  else
      # This is used in PS1 below, so at least define it
      alias __git_ps1=
  fi
fi

# set color prompt if it is supported
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\]@\[\033[0;36m\]\h\w\[\033[0;32m\]$(__git_ps1)\n\[\033[0;32m\]->\[\033[0m\033[0;32m\] \$\[\033[0m\] '
else
   # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='\u @ \h\w$(__git_ps1)\n->\$ '
fi

unset color_prompt

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    # use monokai ls dircolors
    eval `dircolors $HOME/.dircolors.monokai`
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Run a single ssh-agent over all shells
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# ls aliases

#for *BSD/darwin, --color=auto does not work, export CLICOLOR instead
export CLICOLOR=1
ls --color=auto &> /dev/null && alias ls='ls --color=auto' ||

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# miscellaneous settings etc
alias ffs="sudo chown -R ohthehugemanatee ."

alias clipboard="wl-copy"

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
setopt INC_APPEND_HISTORY

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=40000

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe.sh ] && eval "$(SHELL=/bin/sh lesspipe.sh)"


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias mmkdir='mkdir -m 770 -p'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Tunneling proxy alias
alias sshproxy='ssh -D 8080 -Nf '

# gpg
GPG_TTY=$(tty)
export GPG_TTY
export GPGKEY=758F4A3F


# tmp file
alias tmp='vim ~/tmp/tmp.txt'

# SSH should have the right TermInfo set. (Alacritty sets its own locally)
alias ssh='TERM=xterm-color ssh'

# Wal solarized colorscheme.
# (cat ~/.cache/wal/sequences &)
#wal -e -n -q --theme solarized

alias cptmp='cat ~/tmp/tmp.txt|wl-copy'

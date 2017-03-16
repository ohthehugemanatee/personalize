# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm|xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
  export CLICOLOR=1

  # Use a nicer, color prompt.  Red if I'm root. (borrowed from Gentoo)
  if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\]\h\[\033[0;34m\] \W\[\033[0;33m\]$(parse_git_branch) \n\$\[\033[00m\] '
  else
    PS1='\[\033[01;32m\]\h\[\033[0;34m\] \w\[\033[0;33m\]$(parse_git_branch) \n\$\[\033[00m\] '
  fi
else
    PS1='\u@\h:\w\\n$ '
    #OR Super Simple
    #PS1=#
fi
unset color_prompt



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

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin" 

# Put /user/local/bin at the front of PATH
PATH=/usr/local/bin:$PATH

# Local bashrc
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

export NVM_DIR="/home/ohthehugemanatee/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

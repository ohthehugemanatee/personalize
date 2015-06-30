# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Map vi to vim
alias vi='vim'

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
color_prompt=yes

function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

if [ "$color_prompt" = yes ]; then
  export CLICOLOR=1

  # Use a nicer, color prompt.  Red if I'm root. (borrowed from Gentoo)
  if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[01;31m\]\h\[\033[0;34m\] \W\[\033[0;33m\]$(parse_git_branch) \$\[\033[00m\] '
  else
    PS1='\[\033[01;32m\]\h\[\033[0;34m\] \w\[\033[0;33m\]$(parse_git_branch) \$\[\033[00m\] '
  fi
else
    PS1='\u@\h:\w\$ '
    #OR Super Simple
    #PS1=#
fi
unset color_prompt

# Some aliases
alias ll='ls -l'
alias la='ls -la'
alias mmkdir='mkdir -m 770 -p'

# SSH aliases
alias shclients='ssh cvertesi@clients.trellon.org'
alias shdev='ssh cvertesi@dev.trellon.org'
alias shprod='ssh cvertesi@trellon.com'
alias shswear='ssh cvertesi@swearingatcomputers.com'
alias shcbc='ssh cvertesi@cbcny.org'
alias shsymph='ssh cvertesi@nodesymphony.com'

# Tunneling proxy alias
alias sshproxy='ssh -D 8080 -Nf '

# Local bashrc
# ~/.bashrc.local should contain any local modifications you want to make
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

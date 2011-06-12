# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable colors in the term, and for grep
export CLICOLOR=1
alias grep='grep --color=auto'

# If color is available, use a nicer, color prompt.  Red if I'm root. (borrowed from Gentoo)

if [[ ${EUID} == 0 ]] ; then
  PS1='\[\033[01;31m\]\h\[\033[0;34m\] \W \$\[\033[00m\] '
else
  PS1='\[\033[01;32m\]\u@\h\[\033[0;34m\] \w \$\[\033[00m\] '
fi


# Map vi to vim
alias vi='vim'

# SSH aliases
alias shclients='ssh cvertesi@clients.trellon.org'
alias shdev='ssh cvertesi@dev.trellon.org'
alias shprod='ssh cvertesi@trellon.com'
alias shswear='ssh cvertesi@swearingatcomputers.com'

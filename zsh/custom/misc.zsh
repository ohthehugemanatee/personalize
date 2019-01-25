# miscellaneous settings etc
alias ffs="sudo chown -R ohthehugemanatee ."

alias clipboard="xsel -ib"

# color scheme for directories
eval `dircolors $HOME/.dir_colors/dircolors`

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
setopt INC_APPEND_HISTORY

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=4000

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

# Add composer to PATH
export PATH="$PATH:$HOME/.composer/vendor/bin"

# Add go binaries to PATH
export PATH="$PATH:$HOME/go/bin"

# Add yarn binaries to PATH
export PATH="$PATH:$HOME/.yarn/bin"

# Put /user/local/bin at the front of PATH
PATH=/usr/local/bin:$PATH

# gpg
GPG_TTY=$(tty)
export GPG_TTY
export GPGKEY=758F4A3F

# packages installed with pip
export PATH=$PATH:$HOME/.local/bin

# Toggl Desktop needs this to size the fonts.
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# phpunit test from the repo root
alias phpu='SIMPLETEST_BASE_URL=http://localhost SIMPLETEST_DB=sqlite://localhost//tmp/db.sqlite $PWD/vendor/bin/phpunit -c $PWD/web/core --verbose'

# hidpi support for Qt apps
QT_DEVICE_PIXEL_RATIO=2
QT_AUTO_SCREEN_SCALE_FACTOR=2

# tmp file
alias tmp='vi ~/tmp/tmp.txt'

# s-tui hw monitor
alias monitor='s-tui'

# msftvpn
alias msftvpn="sudo sed -i '1i###Begin MSFTVPN\nsearch corp.microsoft.com\nnameserver 10.221.18.5\n###End MSFTVPN' /etc/resolv.conf && /usr/local/bin/msftvpn; sudo perl -0777 -pi -e 's/###Begin MSFTVPN(.*)###End MSFTVPN\n//igs' /etc/resolv.conf"

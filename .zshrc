# Include antigen plugin manager
source $HOME/personalize/linux/antigen.zsh
antigen use oh-my-zsh

antigen theme https://github.com/yupswing/yupgnoster.git yupgnoster
DEFAULT_USER="ohthehugemanatee"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"
# Path to your oh-my-zsh installation.
export ZSH=/home/ohthehugemanatee/.oh-my-zsh

# Which plugins would you like to load? (built-in plugins can be found in ~/.oh-my-zsh/plugins/*)
# Add wisely, as too many plugins slow down shell startup.
antigen bundle git
antigen bundle git-extras
antigen bundle command-not-found
antigen bundle common-aliases
antigen bundle docker
antigen bundle sudo
antigen bundle systemd
antigen bundle wd
antigen bundle taskwarrior
antigen bundle z
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle gpg-agent
# my custom scripts
antigen bundle $HOME/personalize/zsh/custom --no-local-clone

antigen apply

# Start sway on login.
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  export MOZ_ENABLE_WAYLAND=1
  export GTK_BACKEND=wayland
  export QT_QPA_PLATFORM=wayland
  #  exec sway -d 2> ~/sway.log
  exec sway
fi


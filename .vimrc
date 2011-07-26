" My personal vim config

" Editor behaviors
set nocompatible " to get all the Vim-only options
syntax enable " enable syntax highlighting
filetype plugin indent on "enable filetype detection
set showmode  " shows the current mode
set backspace=indent,eol,start "backspaces behave like backspaces
set hidden "good multi-file behaviors
set wildmenu "better command line completion
set wildmode=list:longest " completion acts like the shell
set ignorecase	"case-insensitive searching
set smartcase "unless there's a capital letter there
set ruler "show cursor position in the corner
set hlsearch "highlight search matches
set incsearch "highlight search matches as I type
set laststatus=2 " Always show a status line at the bottom
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P


"Tab sizes - use 2 spaces for tab spacing
set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab "save as spaces rather than tabs


"Normal stuff

set wrap  "linewraps
set scrolloff=5 "always show 5 lines before/after the cursor
set title "update term title
set visualbell "turn off audio beeps


"Solarized VIM color scheme
set background=dark
let g:solarized_termcolors=16
colorscheme solarized

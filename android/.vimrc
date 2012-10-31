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
set number "turn on line number display

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
let g:vimsyn_folding='af' "code folding


"Solarized VIM color scheme
set background=dark
let g:solarized_termcolors=16
colorscheme solarized
""""""""""""""""""""""""""""""""""""""""""""""""
" .vimrc default setup file for Terminbal IDE  "
"                                              "
" Creator : Spartacus Rex                      "
" Version : 1.0                                "
" Date    : 9 Nov 2011                         "
""""""""""""""""""""""""""""""""""""""""""""""""

"The basic settings
"set nocp
"set ls=2
"set tabstop=4
"set ruler
"set number
"set ignorecase
"set modeline
"set autoindent
"set nobackup
"set wrap
"set hidden
"set backspace=indent,eol,start

"Syntax highlighting
"syntax on

"Yes filetype matter
"filetype plugin on

"Set a nice Omnifunc - <CTRL>X <CTRL>O
set ofu=syntaxcomplete#Complete

"Source a few scripts at startup
"source ~/.vim/autoload/javacomplete.vim

"Set some nice java functions - <CTRL>X <CTRL>U
"set completefunc=javacomplete#Complete

"Make javac the build prog - :make
"You will need to change this per project to account for libs..
"Choose on of the following for starters
"YOU MUST start vim from the 'src/' folder. or javac wont work..

"This is the simplest possible
"autocmd Filetype java set makeprg=javac\ %

"This is a good default one - works for projects without libs
"autocmd Filetype java set makeprg=javac\ -d\ ../build/\ %

"Mapped some FUNCTION keys to be more useful..
map <F7> :make<Return>:copen<Return>
map <F8> :cprevious<Return>
map <F9> :cnext<Return>

"This is a nice buffer switcher
:nnoremap <F5> :buffers<CR>:buffer<Space>

" These are useful when using MinBufExpl
" BUT the CTRL+ARROW key mappings are still wrong on Terminal IDE soft Keyboard..
" This will only work over telnet/ssh . Fix Soon.
"let g:miniBufExplMapWindowNavVim    = 1
"let g:miniBufExplMapWindowNavArrows = 1

"You can change colors easily in vim. 
"Just type <ESC>:colorscheme and then TAB complete through the options 
"colorscheme desert
"set background=dark

"Set the color for the popup menu
:highlight Pmenu ctermbg=blue ctermfg=white
:highlight PmenuSel ctermbg=blue ctermfg=red
:highlight PmenuSbar ctermbg=cyan ctermfg=green
:highlight PmenuThumb ctermbg=white ctermfg=red

" DICTIONARY
" The dictioanry can pop up a lot of words when you have Auto popup enabled. 
" You can disable auto popup, by removing the acp.vim from your ~/.vim/plugin/
" directory and enable the dictionary here - then use <CTRL>X <CTRL>K to bring
" up the dictionary options. Or just enable it.. :-)
"set dictionary+=~/system/etc/dict/words

" Make vim popup behave more like an IDE POPUP
set completeopt=longest,menuone

" Make enter finish the completion popup menu
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"Auto start NERDTree on startup..
"autocmd VimEnter * NERDTree
"autocmd VimEnter * wincmd p



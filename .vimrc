" Following lines added by drush vimrc-install on Sat, 07 Sep 2013 12:59:47 +0000.
set nocompatible
" call pathogen#infect('/Users/campbellvertesi/.drush/vimrc/bundle')
call pathogen#infect('/$HOME/.drush/vimrc/bundle/{}')
" call pathogen#infect('/Users/campbellvertesi/.vim/bundle')
call pathogen#infect('/$HOME/.vim/bundle/{}')
" End of vimrc-install additions.

source $VIMRUNTIME/vimrc_example.vim
" My personal vim config

" Editor behaviors
filetype off " required for Vundle
set nocompatible " to get all the Vim-only options
syntax enable " enable syntax highlighting
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
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//
set directory=/tmp//
set wrap  "soft linewraps
set formatoptions-=t " disable hard linewraps
set scrolloff=5 "always show 5 lines before/after the cursor
set title "update term title
set visualbell "turn off audio beeps


" Drupal coding standards for syntastic
let g:syntastic_phpcs_conf="--standard=DrupalCodingStandard"

"Tab sizes - use 2 spaces for tab spacing
set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab "save as spaces rather than tabs


" begin new explorer shit
fun! VexToggle(dir)
  if exists("t:vex_buf_nr")
    call VexClose()
  else
    call VexOpen(a:dir)
  endif
endf

fun! VexOpen(dir)
  let g:netrw_browse_split=4    " open files in previous window
  let vex_width = 35 

  execute "Vexplore " . a:dir
  let t:vex_buf_nr = bufnr("%")
  wincmd H

  call VexSize(vex_width)
endf
noremap <Leader><Tab> :call VexToggle(getcwd())<CR>
noremap <Leader>` :call VexToggle("")<CR>

fun! VexClose()
  let cur_win_nr = winnr()
  let target_nr = ( cur_win_nr == 1 ? winnr("#") : cur_win_nr )

  1wincmd w
  close
  unlet t:vex_buf_nr

  execute (target_nr - 1) . "wincmd w"
  call NormalizeWidths()
endf

fun! VexSize(vex_width)
  execute "vertical resize" . a:vex_width
  set winfixwidth
  call NormalizeWidths()
endf

fun! NormalizeWidths()
  let eadir_pref = &eadirection
  set eadirection=hor
  set equalalways! equalalways!
  let &eadirection = eadir_pref
endf
augroup NetrwGroup
  autocmd! BufEnter * call NormalizeWidths()
augroup END

let g:netrw_liststyle=0         " thin (change to 3 for tree)
let g:netrw_banner=0            " no banner
let g:netrw_altv=1              " open files on right
let g:netrw_preview=1           " open previews vertically

" Change directory to the current buffer when opening files.
set autochdir

" end new explorer shit
" Enable omni completion (<C-X><C-O> when in Insert mode)
set omnifunc=syntaxcomplete#Complete
" Autocomplete behavior - complete as you type, use Enter to select.
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : <C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

"Solarized VIM color scheme
set background=dark
let g:solarized_termcolors=16
colorscheme solarized
let g:solarized_contrast="high"

" Tagbar Toggle
nmap <C-T> :TagbarToggle<CR> 

" Vundle setup.
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" End Vundle setup.

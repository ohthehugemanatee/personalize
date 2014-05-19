" Following lines added by drush vimrc-install on Sat, 07 Sep 2013 12:59:47 +0000.
set nocompatible
" call pathogen#infect('/Users/campbellvertesi/.drush/vimrc/bundle')
call pathogen#infect('/$HOME/.drush/vimrc/bundle/{}')
" call pathogen#infect('/Users/campbellvertesi/.vim/bundle')
call pathogen#infect('/$HOME/.vim/bundle/{}')
" End of vimrc-install additions.

source $VIMRUNTIME/vimrc_example.vim
filetype plugin on
filetype plugin indent on
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
set backupdir =~/.vim/backup
set wrap  "linewraps
set scrolloff=5 "always show 5 lines before/after the cursor
set title "update term title
set visualbell "turn off audio beeps



"Tab sizes - use 2 spaces for tab spacing
set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab "save as spaces rather than tabs

" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <C-E> :call ToggleVExplorer()<CR>

" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 4
let g:netrw_altv = 1

" Default to tree mode
let g:netrw_liststyle=3

" Change directory to the current buffer when opening files.
set autochdir

" Enable omni completion (<C-X><C-O> when in Insert mode)
set omnifunc=syntaxcomplete#Complete
" Autocomplete behavior - complete as you type, use Enter to select.
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'


"Solarized VIM color scheme
set background=dark
let g:solarized_termcolors=16
colorscheme solarized

let g:syntastic_phpcs_conf="--standard=DrupalCodingStandard"



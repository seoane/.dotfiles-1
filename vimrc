" Bundle
" Non compatible with vi
set nocompatible
filetype off                  " required
set encoding=utf-8

call plug#begin()

" Plugins
Plug 'AndrewRadev/switch.vim'
Plug 'EinfachToll/DidYouMean'
Plug 'SirVer/ultisnips'
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-g-dot'
Plug 'christoomey/vim-sort-motion'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'gorodinskiy/vim-coloresque'
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-peekaboo'
Plug 'luochen1990/rainbow'
Plug 'majutsushi/tagbar'
Plug 'matchit.zip'
Plug 'moll/vim-bbye'
Plug 'ntpeters/vim-better-whitespace'
Plug 'rking/ag.vim'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-multiple-cursors'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-ruby/vim-ruby'

" Text objects pre
Plug 'kana/vim-textobj-user'
" Text objects
Plug 'glts/vim-textobj-comment'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'tek/vim-textobj-ruby'
Plug 'whatyouhide/vim-textobj-erb'

" Tags
Plug 'xolox/vim-misc'
Plug 'xolox/vim-easytags'

" Color
Plug 'nanotech/jellybeans.vim'
Plug 'NLKNguyen/papercolor-theme'

" Experimental
Plug 'tpope/vim-rails'
Plug 'cohama/lexima.vim'
Plug 't9md/vim-ruby-xmpfilter'

call plug#end()

" GUI --------------------------------------------------
if has("gui_running")
  " Maximize gvim window (on my screen)
  set lines=40 columns=150
  set guifont=DejaVu\ Sans\ Mono\ for\ Powerline
endif

" Misc --------------------------------------------------
set autoread                                     " Reload file if changed
set backspace=indent,eol,start
set cpoptions+=$                                 " Show $ with 'cw' and similar commands
set gdefault                                     " Assume /g flag on :s substitutions
set hidden                                       " Edit various files without saving or undoing
set lazyredraw                                   " Fast macros
set linebreak
set listchars=eol:↲,tab:▶\ ,extends:>,precedes:<
set noerrorbells                                 " Don't beep
set noshowmode                                   " Don't show current mode down the bottom (airline does)
set nowrap                                       " Don't warp lines
set nrformats-=octal
set number                                       " Show absolute line number
set scrolloff=1
set showcmd                                      " Show incomplete cmds down the bottom
set showmatch                                    " Show matching brackets when text indicator is over them
set splitbelow
set splitright
set ttyfast
set virtualedit=block
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " Binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " Compiled object files
set wildignore+=*.orig
set wildignore+=.hg,.git,.svn                    " Version control
set wildmenu                                     " Enable tab
set wildmode=list:full,full

" .tex files are LaTeX, not plaintex
let g:tex_flavor = "latex"

filetype plugin indent on

" Reaction time
set timeoutlen=500
set ttimeoutlen=100


" Colorscheme
let g:jellybeans_overrides = {
\ 'Cursor': { 'guibg': 'ff00ee', 'guifg': 'ffffff' },
\ 'Search': { 'guifg': '00dddd', 'attr': 'underline' },
\}
colorscheme jellybeans " Dark
" colorscheme PaperColor " Light

" Dont backup files
set nobackup
set noswapfile

" Status line
set stl=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]
set laststatus=2 " Allways show status line

" Searching configs
set hlsearch            " Highlight search
set noignorecase        " Dont ignore case
set incsearch
set magic               " Magic REGEX


" Do not continue comments when adding a line with o/O
augroup no_comments_oO
    autocmd!
    autocmd BufEnter * set formatoptions-=o
augroup END


" Tab settings
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set autoindent
set smartindent


" Store undo info inside .vim/undo
if exists("+undofile")
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=~/.vim/undo//
  set undofile
endif

" Tab wrapper
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Visual Mode search with */# from Scrooloose
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<cr>//<cr><c-o>
vnoremap # :<C-u>call <SID>VSetSearch()<cr>??<cr><c-o>

" Do not highlight trailing whitespace in insert mode
augroup whitespace
    autocmd!
    autocmd InsertEnter * :DisableWhitespace
    autocmd InsertLeave * :EnableWhitespace
augroup END

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --ignore ".git" --nocolor --hidden -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Maps --------------------------------------------------
" Leader is <space>
nnoremap <space> <nop>
vnoremap <space> <nop>
let mapleader=" "

" Edit vimrc and source vimrc
nnoremap <silent> <leader>ev :edit $MYVIMRC<cr>
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>:AirlineRefresh<cr>

" Toggle paste mode
nmap <silent> <F2> :set paste!<cr>
set pastetoggle=<F2>
" Remove paste when leaving Insert mode
augroup my_paste_group
    autocmd!
    autocmd InsertLeave * set nopaste
augroup END

" Command line bindings
command! W w
cnoremap jk <esc>
cnoremap kj <esc>
cnoremap w!! w !sudo tee % >/dev/null

" Open and close folds
nnoremap <leader><leader> za
nnoremap <leader>j zaj
nnoremap <leader>k zak

" Toggle hlsearch
nnoremap <silent> <leader><cr> :set hlsearch!<cr>

" Fix Y weird behaivour
nnoremap Y y$

" Toggle line wrap
nnoremap <leader>tw :windo set wrap!<cr>
" Show current line
nnoremap <leader>tl :set cursorline!<cr>
" Show chars
nnoremap <leader>tc :set list!<cr>

" Quick save and quit
nnoremap <leader>q :q<cr>
nnoremap <leader>Q :qa!<cr>
nnoremap <leader>w :w<cr>

" Update diffs
nnoremap du :diffupdate<cr>

" Exit insert mode
inoremap jk <ESC>
inoremap kj <ESC>

" Exit visual mode
vnoremap <leader><leader> <ESC>

" Select pasted text
noremap gV `[V+`]

" Stop annoying :q menu
noremap q: :q

" Format paragraph with Q
nnoremap Q gqip
vnoremap Q gq

" Buffers
nnoremap <leader>n :bn<cr>
nnoremap <leader>p :bp<cr>
nnoremap <leader>bd :Bdelete<cr>

" Quickfix
nnoremap <leader>N :cnext<cr>
nnoremap <leader>P :cprevious<cr>
nnoremap <leader>O :cwindow<cr>
" make
nnoremap <leader>m :make!<cr>:cwindow<cr>

" Virtual lines are real lines
nnoremap j gj
nnoremap k gk
nnoremap 0 g0
nnoremap $ g$

vnoremap j gj
vnoremap k gk
vnoremap 0 g0
vnoremap $ g$

" Start and end of line on command mode
cnoremap <c-a> <home>
cnoremap <c-e> <end>

" Using spanish keyboard this is better
" , to next f/F/t/T
" ; to previous f/F/t/T
nnoremap ; ,
nnoremap , ;
vnoremap ; ,
vnoremap , ;

" Swap 0/^ and '/`
nnoremap 0 ^
nnoremap ^ 0
nnoremap ` '
nnoremap ' `

" Plugin Config --------------------------------------------------
" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts=1

" Ag.vim
nnoremap <leader>a :Ag<space>

" Commentary
augroup commentstrings
    autocmd!
    autocmd FileType matlab set commentstring=%%s
augroup END

" EasyTag
set tags=./tags;
let g:easytags_dynamic_files = 2

" Fzf
let g:fzf_command_prefix = 'Fzf'

" Tagbar
nnoremap <silent> <leader>tt :TagbarToggle<cr>
let g:tagbar_autoclose = 1
let g:tagbar_sort = 0

" Rainbow
let g:rainbow_active = 0
nnoremap <leader>tr :RainbowToggle<cr>
let g:rainbow_conf = {
  \ 'ctermfgs': [
  \   'brown',
  \   'Darkblue',
  \   'darkgray',
  \   'darkgreen',
  \   'darkcyan',
  \   'darkred',
  \   'darkmagenta',
  \   'brown',
  \   'gray',
  \   'black',
  \   'darkmagenta',
  \   'Darkblue',
  \   'darkgreen',
  \   'darkcyan',
  \   'darkred',
  \   'red',
  \ ]
\ }

" Switch
let g:switch_mapping = "gS"
augroup my_switch_group
    autocmd!
    autocmd FileType gitrebase let b:switch_custom_definitions =
        \ [
        \   {
        \     'pick': 'reword',
        \     'reword': 'edit',
        \     'edit': 'squash',
        \     'squash': 'fixup',
        \     'fixup': 'pick',
        \   },
        \ ]
augroup end

" UltiSnips
inoremap <c-j> <nop>
inoremap <c-k> <nop>
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
nnoremap <leader>es :UltiSnipsEdit<cr>

" Vim-easy-align
nmap ga <Plug>(LiveEasyAlign)
xmap ga <Plug>(LiveEasyAlign)
xmap <Enter> <Plug>(LiveEasyAlign)

" Vim-fugitive
nnoremap <leader>gb  :Gblame<cr>
nnoremap <leader>gc  :Gcommit<cr>
nnoremap <leader>gd  :Gdiff<cr>
nnoremap <leader>gm  :Gmove<space>
nnoremap <leader>gs  :Gstatus<cr>

" Vim-gitgutter
let g:gitgutter_diff_args = '-w'
let g:gitgutter_sign_column_always = 1

" Vim-ruby-xmpfilter
let g:xmpfilter_cmd = "seeing_is_believing"

augroup seeing_is_believing
    autocmd FileType ruby nmap <buffer> <M-m> <Plug>(seeing_is_believing-mark)
    autocmd FileType ruby xmap <buffer> <M-m> <Plug>(seeing_is_believing-mark)
    autocmd FileType ruby imap <buffer> <M-m> <Plug>(seeing_is_believing-mark)

    autocmd FileType ruby nmap <buffer> <M-c> <Plug>(seeing_is_believing-clean)
    autocmd FileType ruby xmap <buffer> <M-c> <Plug>(seeing_is_believing-clean)
    autocmd FileType ruby imap <buffer> <M-c> <Plug>(seeing_is_believing-clean)

    " xmpfilter compatible
    autocmd FileType ruby nmap <buffer> <M-r> <Plug>(seeing_is_believing-run_-x)
    autocmd FileType ruby xmap <buffer> <M-r> <Plug>(seeing_is_believing-run_-x)
    autocmd FileType ruby imap <buffer> <M-r> <Plug>(seeing_is_believing-run_-x)

    " auto insert mark at appropriate spot.
    autocmd FileType ruby nmap <buffer> <F5> <Plug>(seeing_is_believing-run)
    autocmd FileType ruby xmap <buffer> <F5> <Plug>(seeing_is_believing-run)
    autocmd FileType ruby imap <buffer> <F5> <Plug>(seeing_is_believing-run)

augroup end

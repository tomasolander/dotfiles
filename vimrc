set encoding=utf-8

" Always use English on Windows
if has("win32")
  set langmenu=en_US.UTF-8
  language English_United States
endif

" Leader
let mapleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Easier tab navigation
nnoremap <C-left> :tabn<CR>
nnoremap <C-right> :tabp<CR>

" Better navigation for beginning / end of line
nnoremap H ^
nnoremap L $

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces

" Use ripgrep
if executable('rg')
  let g:ctrlp_user_command = 'rg --files -F -w %s'
  let g:ctrlp_use_caching = 0
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
elseif executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag -Q -l --nocolor --hidden -g "" %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" FZF
fun! s:fzf_root()
  let path = finddir(".git", expand("%:p:h").";")
  return fnamemodify(substitute(path, ".git", "", ""), ":p:h")
endfun

" FZF Rg shortcut
nnoremap <C-f> :Rg 
nnoremap <expr> <M-f> ':Rg '.expand('%:t').'<CR>'
nnoremap <expr> ƒ ':Rg '.expand('%:t').'<CR>'
nnoremap <expr> <C-g> ':Rg '.expand("<cword>").'<CR>'

" Override Ctrl+P with FZF
if has("gui_running") == 0
  let g:ctrlp_map = ''
  nnoremap <silent> <c-p> :exe 'Files ' . <SID>fzf_root()<CR>
endif

" More results!
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Gutentags
augroup MyGutentagsStatusLineRefresher
  autocmd!
  autocmd User GutentagsUpdating call lightline#update()
  autocmd User GutentagsUpdated call lightline#update()
augroup END

function LightlineTags()
  let l:state = gutentags#statusline()
  if l:state =~ 'ctags'
    return '☯'
  endif
  return ''
endfunction

" Statusline/Lightline stuff
let g:lightline = {
  \ 'colorscheme': 'powerline',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'readonly', 'filename', 'modified' ],
  \             [ 'gitbranch', 'gutentags' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head',
  \   'gutentags': 'LightlineTags',
  \ },
  \ }

set tags^=./.git/tags

" Color scheme
colorscheme molokai
set nocursorline

" Kitty workaround
if $TERM == "xterm-kitty"
  let &t_ut=''
  " Set the terminal default background and foreground colors, thereby
  " improving performance by not needing to set these colors on empty cells.
  "hi Normal guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE
  "let &t_ti = &t_ti . "\033]10;#F8F8F2\007\033]11;#1B1D1E\007"
  "let &t_te = &t_te . "\033]110\007\033]111\007""
endif

" Numbers
set number
set numberwidth=5
set relativenumber
" This makes relative numbers work in Netrw
let g:netrw_bufsettings = 'noma nomod nu nowrap ro nobl'

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full

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

" Easy duplication in visual mode
vmap D y'>p

" C++ interface copy-pasting.
vnoremap . :s/virtual \(.*\) = 0;/\1 override;/g<CR>

" Use shift+T for tag navigation.
nnoremap <S-t> :CtrlPtjump<cr>
let g:ctrlp_tjump_only_silent = 1

" Tagbar
nnoremap <F8> :TagbarToggle<CR>
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_autopreview = 1
let g:tagbar_show_linenumbers = -1

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" EasyMotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map <F10> <Plug>(easymotion-overwin-f)
nmap <Leader>s <Plug>(easymotion-overwin-f)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" jsx highlighting
let g:jsx_ext_required = 0

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
" See https://github.com/thoughtbot/dotfiles/issues/655#issuecomment-605019271
if &diff
    set diffopt-=internal
    set diffopt+=vertical
endif

" Persistent undo
set undodir=~/.vim/undo
set undofile

" Use case sensitivity while searching only when capital letters are used
set ignorecase
set smartcase

" s///g by default
set gdefault

" Always have five lines of context
set scrolloff=5

" Enable mouse scroll
set mouse=a

" Make background transparent
hi Normal guibg=NONE ctermbg=NONE

" Windows customizations
if has("win32")
  set guifont=Consolas:h10:cANSI:qDRAFT
  set undodir=~/vimfiles/undo
endif

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

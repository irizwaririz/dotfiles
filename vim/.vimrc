" ---------------------------------- System ----------------------------------
" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible
" Automatically refresh currently opened file/s when the file/s have been
" changed outside of vim.
set autoread
" Copy/Paste/Cut using system clipboard.
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100
" Make vim put the swap, backup, and undofiles in a special directory instead
" of the working directory.
" NOTE: Using double trailing slashes (e.g. ~/.vim/swap//) tells vim to enable
" a feature where it avoids name collisions (i.e. same file names but different
" paths) by using the whole path of the files instead.
let &directory = expand('~/.vim/cache/swap//')

set backup
let &backupdir = expand('~/.vim/cache/backup//')

set undofile
let &undodir = expand('~/.vim/cache/undo//')
" Create those directories (with full permissions for the owner and no
" permissions for anyone else) if they don't exist.
if !isdirectory(&undodir) | call mkdir(&undodir, "p", 0700) | endif
if !isdirectory(&backupdir) | call mkdir(&backupdir, "p", 0700) | endif
if !isdirectory(&directory) | call mkdir(&directory, "p", 0700) | endif
" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden
" Make use of our filetype plugins.
filetype plugin on
" Extend % matching.
packadd! matchit
" Don't wait for a key after Escape in insert mode.
silent! set noesckeys

" ------------------------------ User Interface ------------------------------
" Enable truecolor support.
set termguicolors
" Use gruvbox as our colorscheme (in dark mode).
colorscheme solarized
set background=dark
" Show (partial) commands in status line.
set showcmd
" Turn on syntax highlighting.
syntax on
" Better command-line completion.
set wildmenu
" Pressing tab completes till longest common string and list all matches
set wildmode=list:longest,list:full
" Case insensitive command-line completion.
set wildignorecase
" Disable the default Vim startup message.
set shortmess+=I
" Show line numbers.
set number
" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber
" Always show the status line at the bottom, even if you only have one window
" open.
set laststatus=2
" Disable audible/visual bell because it's annoying.
set noerrorbells visualbell t_vb=
" Adds a vertical line on the 80th column for visual reference.
set colorcolumn=80
highlight ColorColumn ctermbg=238
" Use the same background as the terminal emulator.
highlight Normal ctermbg=NONE
" Leaves 8 lines of code as an allowance while scrolling up/down.
set scrolloff=8
" Prevent line wrapping.
set nowrap
" Put vertical window splits to the right.
set splitright
" Put horizontal window splits below.
set splitbelow
" Show row and column number of cursor position.
set ruler
" Give more space for displaying messages
set cmdheight=2

" --------------------------- Tabs and Indentation ---------------------------
" NOTE: ftplugins will tweak this accordingly.
" Number of visual spaces per TAB.
set tabstop=4
" Number of spaces in TAB when editing.
set softtabstop=4
" Number of spaces indented when reindent operations (>> and <<) are used.
set shiftwidth=4
" Convert TABs to spaces.
set expandtab
" Enable intelligent tabbing and spacing for indentation and alignment.
" set smarttab
" When opening a new line and no file-specific indenting is enabled,
" keep same indent as the line you're currently on.
set autoindent

" --------------------------------- Searching --------------------------------
" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase
" Enable searching as you type, rather than waiting till you press enter.
set incsearch
" Enable highlighting of all search term matches.
set hlsearch
" Show search count message when searching, e.g. '[1/5]'
set shortmess-=S

" ----------------------------- General Mappings -----------------------------
" This will make Y behave like D/C.
nnoremap Y y$

" TODO: PUT IN AUTOLOAD
" This will allow us to apply macros to visually selected lines (per line)
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
endfunction
" Easily toggle paste mode.
set pastetoggle=<F2>

" -------------------------- General Leader Mappings -------------------------
" Set leader key to spacebar.
let mapleader = " "
" Resize windows easily.
nnoremap <leader>+ :vertical resize +10<CR>
nnoremap <leader>- :vertical resize -10<CR>
" Easily do black hole register deletion (i.e. really delete not cut).
nmap <leader>d "_d
" Easily copy relative filepath of current file to the clipboard
nnoremap <leader>cp :let @+=@%<CR>

" TODO: PUT IN AUTOLOAD
" ----------------------------- Window Splits Zoom ---------------------------
" Function that toggles zooming in and out of a specific window split.
function! ToggleZoom(toggle)
    if exists("t:restore_zoom") && (t:restore_zoom.win != winnr() || a:toggle == v:true)
        exec t:restore_zoom.cmd
        unlet t:restore_zoom
    elseif a:toggle
        let t:restore_zoom = { 'win': winnr(), 'cmd': winrestcmd() }
        vertical resize | resize
    endif
endfunction

" This autocommand makes it so that it automatically zooms out (if currently
" zoomed in) if we move to another window split that is not the currently
" zoomed window split. It aims to mimic tmux's auto-unzoom effect.
augroup restorezoom
    autocmd!
    autocmd WinEnter * silent! :call ToggleZoom(v:false)
augroup END

" Easily zoom in/out window splits.
nnoremap <leader>z :call ToggleZoom(v:true)<CR>

" --------------------------------- Movement ---------------------------------
" The backspace key has slightly unintuitive behavior by default. For example,
" by default, you can't backspace before the insertion point set with 'i'.
" This configuration makes backspace behave more reasonably, in that you can
" backspace over anything.
set backspace=indent,eol,start
" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a
" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>
" Switch between window splits easily.
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-l> :wincmd l<CR>
" Move text up and down easily then apply the correct indentation.
" Do this in normal mode...
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==
" ...and in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" ----------------------------------- Modes ----------------------------------
" 'Q' in normal mode enters Ex mode. This is disabled for now.
nnoremap Q <Nop>

" --------------------------- Finding/Loading Files --------------------------
" Enable downward search, this makes it so that we can find files deep into
" our directories.
set path=.,**
" Easily search files.
nnoremap <C-p> :find 
" Search files and open in vertical split.
cnoremap <expr> <C-v> getcmdline() =~ '^find .*$' ? '<Home>vert s<End>' : '<C-v>'
" Check list of open buffers and prompt to open a buffer.
nnoremap <leader>b :b <C-d>
" Easily add files in the buffer list.
nnoremap <leader>a :argadd <C-r>=fnameescape(expand('%:p:h'))<CR>/*<C-d>
" Do not display these directories/files in the wildmenu.
set wildignore=*.git/*,*.tags,tags,*venv/*
" Automatically add the wildcard character after every character that is
" usually used in filenames to make :find behave like a fuzzy finder.
for i in split('abcdefghijklmnopqrstuvwxyz1234567890_-', '\zs')
    execute printf("cnoremap <expr> %s getcmdline() =~ 'find .*$' ? '*%s' : '%s'", i ,i ,i)
endfor

" ----------------------------------- Ctags ----------------------------------
" - Use <C-]> to jump to tag under cursor.
" - Use g<C-]> for ambiguous tags.
" - Use <C-t> to jump back up the tag stack.
command! MakeTags !ctags -R --exclude=venv .

" ------------------------------- Autocomplete -------------------------------
" - Use <C-n> or <C-p> to autocomplete anything given by the 'complete'
"   option.
" - Use <C-x><C-f> to autocomplete filenames
" Show insert completion messages
set shortmess-=c
" Change how insert mode completion gives suggestions.
set completeopt=menuone,preview,longest

" ----------------------------------- netrw ---------------------------------- 
" Instantiate the netrw explorer window easily.
nnoremap <leader>ft :Lex<CR>
" Remove the netrw mapping of <C-l> to refresh. This is so that our map of
" <C-l> to move to the right window split will still work on netrw.
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END
function! NetrwMapping()
    nnoremap <buffer> <C-l> :wincmd l<CR>
endfunction
" Remove the netrw banner at the top.
let g:netrw_banner=0
" Make netrw list the directories as trees.
let g:netrw_liststyle=3
" Instantiate netrw window with proper window size.
let g:netrw_winsize=20

" ---------------------------------- vimdiff ---------------------------------
" Easily search across files
nnoremap <C-g> :vimgrep // **/*<C-Left><Left><Left>

" ------------------------------- quickfix list ------------------------------
" Easily navigate the quickfix list
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap ]Q :clast<CR>
nnoremap [Q :cfirst<CR>
" Easily open quickfix list window
nnoremap <C-c> :cope<CR>

" -------------------------------- OSC-52 Yank -------------------------------
" Automatically call OSC52 function on yank to sync register with system
" clipboard.
augroup Osc52Yank
    autocmd!
    autocmd TextYankPost *
        \ if v:event.operator is 'y' && v:event.regname is '' |
        \ execute 'OSCYankReg "' |
        \ endif
augroup END
" This makes the plugin with work tmux.
let g:oscyank_term = 'default'
" Remove confirmation message when yanking.
let g:oscyank_silent = v:true

" ------------------------------- extended.vim -------------------------------
" Extend functionality by installing and configuring third party plugins.
runtime extended.vim

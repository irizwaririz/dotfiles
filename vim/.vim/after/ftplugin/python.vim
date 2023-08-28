" Ensure black is installed
if executable('black')
    " Set formatprg
    setlocal formatprg=black\ -q\ -
    " Ensure we use formatprg instead of formatexpr
    setlocal formatexpr=
endif

" Ensure flake8 is installed
if executable('flake8')
    " Set makeprg
    setlocal makeprg=flake8
endif

" Number of visual spaces per TAB.
set tabstop=4
" Number of spaces in TAB when editing.
set softtabstop=4
" Number of spaces indented when reindent operations (>> and <<) are used.
set shiftwidth=4
" Convert TABs to spaces.
set expandtab
" When opening a new line and no file-specific indenting is enabled,
" keep same indent as the line you're currently on.
set autoindent

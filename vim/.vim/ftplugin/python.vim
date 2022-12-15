" Ensure black is installed
if executable('black')
    " Set formatprg
    setlocal formatprg=black\ -q\ -
    " Ensure we use formatprg instead of formatexpr
    setlocal formatexpr=
endif

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

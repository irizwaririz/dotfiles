" ---------------------------------- Plugins ---------------------------------
" Automatic installation of vim-plug if it's not yet installed.
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
" NOTE: The installation won't work if the curl package is not installed.
if has('win32')&&!has('win64')
    let curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
    let curl_exists=expand('curl')
endif

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    if !executable(curl_exists)
        echoerr "You have to install curl or first install vim-plug yourself!"
        execute "q!"
    endif
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" NOTE: This line below is not given in the link above but it's required
" or an error will appear on execution (i.e. PlugInstall is dependent on it).
call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'mbbill/undotree'

" vim must have the popupwin feature for these to work properly.
if has('nvim-0.4.0') || has('patch-8.2.191')
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
endif

" The master branch is async-only and thus requires at least Vim 8.0.902.
" Use the legacy branch for older Vim versions.
if has('nvim') || has('patch-8.0.902')
    Plug 'mhinz/vim-signify'
else
    Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif

call plug#end()

" ------------------------------------ fzf -----------------------------------
" Advanced ripgrep integration (i.e. actually use ripgrep when searching in
" multiple files). This will be mapped to :RG.
function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" Open fzf as a pop-up window in the center.
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
" Open fzf file searching window easily.
nnoremap <C-p> :Files<CR>
" Open fzf ripgrep searching window easily.
nnoremap <C-g> :RG<CR>
" Open git log window easily.
nnoremap <leader>gl :Commits<CR>
" Open buffer list window easily.
nnoremap <leader>b :Buffers<CR>
" Re-map horizontal window split file opening to <C-s> for consistency.
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit'}
" Better fuzzy searching using ripgrep (but only if ripgrep is installed).
" NOTE: Replace `-uu` with `--hidden` if you want to show hidden files but not
" files covered by `.gitignore`s.
if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files -uu --follow --glob "!.git/*" --glob "!venv/*"'
endif

" -------------------------------- vim-signify -------------------------------
" Create dedicated bindings for jumping between hunks (]c/[c is the default
" but it is used by vim to jump between diffs)
nnoremap ]h <plug>(signify-next-hunk)
nnoremap [h <plug>(signify-prev-hunk)

" Show current and total hunks when jumping between hunks.
autocmd User SignifyHunk call s:show_current_hunk()

function! s:show_current_hunk() abort
    let h = sy#util#get_hunk_stats()
    if !empty(h)
        echo printf('[Hunk %d/%d]', h.current_hunk, h.total_hunks)
    endif
endfunction

" --------------------------------- undotree ---------------------------------
" Easily instantiate the undotree window.
nnoremap <leader>u :UndotreeToggle<CR>
" Set cursor/focus on the undotree window after being opened.
let g:undotree_SetFocusWhenToggle = 1
" Instantiate the undotree window with proper window size.
let g:undotree_SplitWidth = 45

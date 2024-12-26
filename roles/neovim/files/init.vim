if exists('g:vscode')
  finish
endif

"------------------------------------------------------------------------------
" vim-plug plugins
"------------------------------------------------------------------------------
call plug#begin('~/.local/share/nvim/plugged')
    Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'vim-scripts/wombat256.vim'
"    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"    Plug 'zchee/deoplete-jedi'
    Plug 'lervag/vimtex'
"    Plug 'jpalardy/vim-slime'
    Plug 'vim-scripts/loremipsum'
    Plug 'vim-scripts/gnupg.vim'
    Plug 'gregsexton/MatchTag'
    Plug 'PProvost/vim-ps1'
    Plug 'Shougo/echodoc'
"    Plug 'alpertuna/vim-header'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
"    Plug 'neomake/neomake'
    Plug 'dag/vim-fish'
    Plug 'OmniSharp/omnisharp-vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
    Plug 'josa42/coc-sh'
    Plug 'alvan/vim-closetag'
    Plug 'cespare/vim-toml'
    Plug 'hashivim/vim-terraform'
    Plug 'direnv/direnv'
    Plug 'wellle/context.vim'
call plug#end()

" MacOS leader key defaults suck shit
let mapleader = ','


" Open/close folds with space bar
nnoremap <space> za
vnoremap <space> zf

set t_te=
set t_ti=

let g:coc_global_extensions = ['coc-jedi', 'coc-yaml', 'coc-sh']


" Paths
let g:coc_node_path = "$XDG_DATA_HOME/asdf/shims/node"

let g:python3_host_prog = "~/.envs/nvim/bin/python"

" yank to clipboard
"set clipboard=unnamedplus

"------------------------------------------------------------------------------
" Plugin options
"------------------------------------------------------------------------------
" deoplete
"    let g:deoplete#enable_at_startup = 1
"    " auto-select first match
"    set completeopt+=noinsert
"    " disable preview window (use echodoc instead)
"    set completeopt-=preview
"    " <CR> cancel popup and insert newline.
"    inoremap <silent> <CR> <C-r>=deoplete#smart_close_popup()<CR><CR>
"    " <TAB> completion.
"    inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
"    call deoplete#custom#option({'smart_case': v:true, 'max_list': 100, 'auto_complete_delay': 100})
"    let g:deoplete#sources#jedi#show_docstring = 1

" echodoc
    set noshowmode
    let g:echodoc#enable_at_startup = 1

" vimtex
    let g:vimtex_compiler_progname = 'nvr'
    let g:vimtex_fold_enabled = 1
    let g:vimtex_fold_manual = 1
    "let g:vimtex_text_obj_enabled = 0
    "let g:vimtex_imaps_enabled = 0
    "let g:vimtex_motion_enabled = 1
    "let g:vimtex_mappings_enabled = 1

" manually set latex filetype
    let g:tex_flavor = 'latex'

" vim-slime
    let g:slime_target = 'neovim'

" neomake
   " call neomake#configure#automake('nrw', 1000)
   " let g:neomake_highlight_lines = 1
   " let g:neomake_python_enabled_makers=['flake8']

" syntastic
    "let g:syntastic_always_populate_loc_list=1
    "let g:syntastic_always_populate_loc_list = 1
    "let g:syntastic_auto_loc_list = 0
    "let g:syntastic_check_on_open = 1
    "let g:syntastic_check_on_wq = 0
    "let g:syntastic_c_checkers = ['make']
    "let g:syntastic_arduino_checkers = ['make']
    "let g:syntastic_rust_checkers = ['cargo build']
    "let g:syntastic_python_checkers = ['flake8']
    "let g:syntastic_python_flake8_args = '--ignore=E501,E231'
    "let g:syntastic_python_flake8_args = '--ignore=E101,E111,E112,E113,E114,E115,E116,E121,E122,E123,E124,E125,E126,E127,E128,E129,E131,E133,E201,E202,E203,E211,E221,E222,E223,E224,E225,E226'
    "let g:syntastic_loc_list_height = 5

" vim-closetag
    let g:closetag_filetypes = 'html,xhtml,phtml,vue'

" NERDtree
    map <F2> :NERDTreeToggle<CR>

" CoC
" ----------------------------------------------------------------------------
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-jedi']

let g:coc_disable_startup_warning = 1

" Ctrl-Space shows CoC list
inoremap <silent><expr> <c-space> coc#refresh()
" Make Up/Down Arrows work in pop up menu
inoremap <expr> <Down> coc#pum#visible() ? coc#pum#next(1) : "\<Down>"
inoremap <expr> <Up> coc#pum#visible() ? coc#pum#prev(1) : "\<Up>"

" Tab / S-Tab to navigate completion list
"inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
"inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

" Tab to select an autocomplete entry
"inoremap <expr> <Tab> pumvisible() ? "\<Space>" : "\<Tab>"
"cnoremap <expr> <Return> pumvisible() ? "\<BS>\<Space>\<BS>\<Tab>\<Tab>" : "\<Return>"
"inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"

" Enter to select an autocomplete entry
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"set wildcharm=<Tab>



" netrw uses tree view
let g:netrw_liststyle = 3
" Remove netrw header
let g:netrw_banner = 0
" netrw opens files in the previous window
let g:netrw_browse_split = 4



"------------------------------------------------------------------------------
" Preferences
"------------------------------------------------------------------------------
set hidden
set number
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smartindent
set expandtab
set smarttab
set ignorecase
set smartcase
set linebreak
set nowrap
set mouse=a
set foldnestmax=2
set foldlevelstart=10
syntax on

:silent! colorscheme wombat256mod

"------------------------------------------------------------------------------
" Auto commands
"------------------------------------------------------------------------------

" Disable expandtab for Makefiles
autocmd FileType make setlocal noexpandtab

" PEP8 Indentation and colorcolumn for .py files
autocmd BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix foldmethod=indent
if exists('+colorcolumn')
	autocmd BufNewFile,BufRead *.py highlight colorcolumn ctermbg=235 guibg=#1D1D1D | let &colorcolumn="80,".join(range(120,999),",")
endif

" 2 space tabs for YAML and JS files
autocmd BufNewFile,BufRead *.yml set tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent
autocmd BufNewFile,BufRead *.js set tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent

" crontab editing in-place
autocmd FileType crontab setlocal nowritebackup

" automagic closing HTML tags
"inoremap <buffer> > ></<C-x><C-o><C-y><C-o>%<CR><C-o>O

" Unfold all folds when first opening
autocmd BufRead * normal zR

" Open .hcl as terraform
au BufNewFile,BufRead *.hcl setlocal ft=tf

" Open .env.* and .envrc as shell
au BufNewFile,BufRead .env.* setlocal ft=sh
au BufNewFile,BufRead .envrc setlocal ft=sh

"------------------------------------------------------------------------------
" Commands and Bindings
"------------------------------------------------------------------------------

" derp, forgot to start as root, force a write
cmap w!! w !sudo tee >/dev/null %

" Show a list of open buffers
nnoremap gb :buffers<CR>:b<Space>

" Strip trailing whitespace on file write
function! StripTrailingWhitespace()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction
autocmd FileType sh,c,cpp,java,php,ruby,python,ino autocmd BufWritePre <buffer> :call StripTrailingWhitespace()

" Toggle between relative and absolute line numbering, map to Ctrl-n
function! ToggleRelativeNumbers()
	if(&relativenumber == 1)
		set norelativenumber
	else
		set relativenumber
	endif
endfunction
nnoremap <C-n> :call ToggleRelativeNumbers()<CR>

" strip a variable of leading and trailing whitespace characters
function! Strip(input_string)
    return substitute(a:input_string, '^[\s\n]*\(.\{-}\)[\s\n]*$', '\1', '')
endfunction


" Jump to Definition
function! JumpToDef()
  if exists("*GotoDefinition_" . &filetype)
    call GotoDefinition_{&filetype}()
  else
    exe "norm! \<C-]>"
  endif
endfunction

" Jump to tag
nnoremap <M-g> :call JumpToDef()<cr>
inoremap <M-g> <esc>:call JumpToDef()<cr>i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" StatusLine background colour changes with current mode
"
" Get a highlight group as a string accepted by :highlight
function! GetHighlightGroup(group)
    let l:hl = execute('hi ' . a:group)
    let l:string = ''
    for item in split(l:hl, '\s\+')
        if match(item, '=') > 0
            let l:kv = split(item, '=')
            let l:string .= ' '.Strip(l:kv[0]).'='.Strip(l:kv[1])
        endif
    endfor
    return l:string
endfunction

let g:default_statusline_highlight = GetHighlightGroup('StatusLine')

au InsertEnter * highlight StatusLine ctermbg=124 gui=bold,reverse guisp=Green
au InsertLeave * execute('highlight StatusLine '.g:default_statusline_highlight)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fixed Preview window height and auto close Preview when leaving insert mode
set previewheight=15
au BufEnter ?* call PreviewHeightWorkAround()
function! PreviewHeightWorkAround()
    if &previewwindow
        exec 'setlocal winheight='.&previewheight
    endif
endfunction
autocmd InsertLeave * if pumvisible() == 0|pclose|endif



"------------------------------------------------------------------------------
" Source file templates
"------------------------------------------------------------------------------

" Header guards for C/C++ headers
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\[\.-]", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! G
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

" C/C++ source file includes default header
function! s:insert_include()
  let include_name = substitute(expand("%:t"), "\.cp*$", ".h", "")
  call append(0, ['#include "'. include_name . '"'])
  normal! G
  startinsert
endfunction
autocmd BufNewFile *.{c,cpp} call <SID>insert_include()

" Python #! and encoding header
function! s:insert_python_header()
  call append(0, [
              \ '#!/usr/bin/env python',
              \ '#vim:fileencoding=utf-8',
              \ '', '',
              \ "if __name__ == '__main__':",
              \ "    pass", "    "
              \])
  call setpos('.', [0, 7, 4])
  startinsert!
endfunction
autocmd BufNewFile *.py call <SID>insert_python_header()

" Bash #! header
function! s:insert_shell_header()
    execute "normal! a#!/bin/sh\n"
    normal! G
    startinsert
endfunction
autocmd BufNewFile *.sh call <SID>insert_shell_header()

" HTML Template
function! s:insert_html_template()
    let name = substitute(expand("%:t"), "\.html$", "", "")
    let title = substitute(name, '\(\<\w\+\>\)', '\u\1', 'g')
    call append(0, [
                \ '<!DOCTYPE html>',
                \ '<html lang="en">',
                \ '<head>',
                \ '    <meta charset="UTF-8">',
                \ '    <title>' . title . '</title>',
                \ '</head>',
                \ '<body>',
                \ '    ',
                \ '</body>',
                \ '</html>'
                \])
    call setpos('.', [0, 8, 4])
    startinsert!
endfunction
autocmd BufNewFile *.html call <SID>insert_html_template()



"------------------------------------------------------------------------------
" Session save and load functions
"------------------------------------------------------------------------------
set sessionoptions-=help
set sessionoptions-=buffers
let g:session_dir = $HOME . "/.config/nvim/sessions"

" Creates a session
function! g:MakeSession()
    let b:sessiondir = g:session_dir . getcwd()
    if (filewritable(b:sessiondir) != 2)
        exe 'silent !mkdir -p ' b:sessiondir
        redraw!
    endif
    let b:sessionfile = b:sessiondir . '/session.vim'
    exe "mksession! " . b:sessionfile
    echo "Session file: " . b:sessionfile
endfunction

" Updates a session if :MakeSession has been called
function! UpdateSession()
    if argc() == 0
        let b:sessiondir = g:session_dir . getcwd()
        let b:sessionfile = b:sessiondir . "/session.vim"
        if (filereadable(b:sessionfile))
            exe "mksession! " . b:sessionfile
            echo "updating session"
        endif
    endif
endfunction

" Loads a session if it exists, skip if there is a current file already
function! LoadSession()
  if @% == ''
    let b:sessiondir = g:session_dir . getcwd()
    let b:sessionfile = b:sessiondir . "/session.vim"
    if (filereadable(b:sessionfile))
      exe 'source ' b:sessionfile
    else
      echo "No session loaded."
    endif
  else
    let b:sessionfile = ""
    let b:sessiondir = ""
  endif
endfunction

" session commands
autocmd VimEnter * nested :call LoadSession()
autocmd VimLeave * :call UpdateSession()
command! MakeSession :call MakeSession()



"------------------------------------------------------------------------------
" Move cursor by display lines when wrapping
" http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
"------------------------------------------------------------------------------
function! g:WrapOn()
    redraw | echom "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    "noremap  <buffer> <silent> <Up>   gk
    "noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    "inoremap <buffer> <silent> <Up>   <C-o>gk
    "inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
endfunction
function! g:WrapOff()
    redraw | echom "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    "silent! nunmap <buffer> <Up>
    "silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    "silent! iunmap <buffer> <Up>
    "silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
endfunction

noremap <silent> <Leader>w :call ToggleWrap()<CR>
function! g:ToggleWrap()
  if &wrap
	:call WrapOff()
  else
	:call WrapOn()
  endif
endfunction

" Turn on wrapping for TeX documents
autocmd FileType tex :call WrapOn()


" Include .vimrc file in the current directory if it exists
if filereadable(".vimrc") && !match($pwd,$HOME)
    source .vimrc
endif

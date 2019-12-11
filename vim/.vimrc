" basic settings {{{
set nocompatible " Don't try to be backwards compatible with vi

set path+=** " subfolder fuzzy-file tab completion

set number " show line numbers
set relativenumber " show relative line numbers
set cursorline " show line under cursor

set showcmd " show incomplete commands in bottom bar
set ruler " show cursor coordinates in bottom bar
set laststatus=2 " Always show statusline

" Scream if lines are too long
highlight ColorColumn ctermbg=magenta guibg=magenta
call matchadd('ColorColumn', '\%81v', 100)

set wildmenu " autocomplete by tabbing
set wildignore+=.git
set wildignore+=a.out,*.o
set lazyredraw " don't redraw in the middle of macros
set showmatch " highlight matching [{()}]

set incsearch
set inccommand=nosplit
set hlsearch

set expandtab
set smarttab
set shiftwidth=2
set tabstop=4
set softtabstop=4

set list
set listchars=tab:\ \ ,extends:❯,precedes:❮
set showbreak=↪

set splitbelow
set splitright

let g:light_colorscheme = "solarized8_light_low"
let g:dark_colorscheme = "solarized8_dark"

" }}}

" autocommands {{{

"execute "autocmd InsertLeave" g:leader_location ":SortLeaderCommands"

augroup vimrc
  autocmd!
  autocmd InsertLeave * :FixWhitespace " Always strip trailing whitespace

  "autocmd BufWritePost ~/.vimrc :source ~/.vimrc

  autocmd FocusLost * :wa

  autocmd VimResized * exe "normal! \<c-w>="

  autocmd VimEnter * :call airline#add_statusline_func('WindowNumber')
  autocmd VimEnter * :call airline#add_inactive_statusline_func('WindowNumber')
  autocmd VimEnter * SetColorScheme
augroup END

augroup cursorlinectl
  autocmd!
  autocmd WinEnter * :set cursorline
  autocmd WinLeave * :set nocursorline
augroup END

augroup ctagsautogenerate
  autocmd!
  autocmd BufWrite *.c,*.cpp,*.h,*.hpp :silent! if getcwd() == $HOME | !ctags -R . | endif
augroup END

augroup filetypecmds
  autocmd!
  autocmd FileType markdown :nnoremap <cr> :execute "!pandoc -F pandoc-crossref % -o /tmp/out.pdf && xdg-open /tmp/out.pdf"<cr>
  "autocmd FileType rust :nnoremap <cr> :!RUST_BACKTRACE=1 cargo run<cr>
  autocmd FileType rust :nnoremap <cr> :!cargo test<cr>
  autocmd FileType tex :nnoremap <cr> :execute "!pdflatex % && mupdf" expand('%:t:r') . ".pdf"<cr>
  autocmd FileType vim :nnoremap <cr> :source %<cr>
  autocmd FileType json syntax match Comment +\/\/.\+$+
  autocmd FileType c,cpp :nnoremap <cr> :!gcc % && ./a.out |
  autocmd FileType html :nnoremap <cr> :!xdg-open %<cr>
augroup END

" }}}

" basic mappings {{{

"nnoremap <Esc> :noh<cr>:echo<cr><Esc>

" escape is too far
inoremap jk <Esc>:w<cr>
inoremap kj <Esc>:w<cr>

" }}}

" leader mappings {{{
let g:leader_location = expand("<sfile>:p")

let mapleader = " "
" leader-begin

" Buffers
nnoremap <leader><TAB> | " Go to previous buffer
nnoremap <silent> <leader>bd :bdelete<cr>|
nnoremap <leader>bl :ls<cr>:buffer<space>|

" Coc
nnoremap <silent> <leader>coa  :<C-u>CocList diagnostics<cr>| " Show all diagnostics
nnoremap <silent> <leader>coc  :<C-u>CocList commands<cr>| " Show commands
nnoremap <silent> <leader>coe  :<C-u>CocList extensions<cr>| " Manage extensions
nnoremap <silent> <leader>coj  :<C-u>CocNext<CR>| " Do default action for next item.
nnoremap <silent> <leader>cok  :<C-u>CocPrev<CR>| " Do default action for previous item.
nnoremap <silent> <leader>coo  :<C-u>CocList outline<cr>| " Find symbol of current document
nnoremap <silent> <leader>cop  :<C-u>CocListResume<CR>| " Resume latest coc list
nnoremap <silent> <leader>cos  :<C-u>CocList -I symbols<cr>| " Search workspace symbols

" Files
nnoremap <leader>fe :edit |
nnoremap <leader>ff :FZF<cr>| " Find file
nnoremap <leader>fs :write<cr>|
nnoremap <leader>fve :edit ~/.vimrc<cr>|
nnoremap <leader>fvs :source ~/.vimrc<cr>|
nnoremap <leader>qq :q<cr>|

" Fold
nnoremap <leader>fdm :set foldmethod=|
nnoremap <leader>fdms :set foldmethod=syntax<cr>|

" Git (fugitive, rhubarb)
nnoremap <leader>gb :Gbrowse<cr>| " Open current github project in browser
nnoremap <leader>gd :Gdiff<cr>| " Diff current file
nnoremap <leader>gf :Gpull<cr>| " Open fugitive git status buffer
nnoremap <leader>gp :Gpush<cr>| " Push project to remote
nnoremap <leader>gs :Gstatus<cr>| " Open fugitive git status buffer

" Make
nnoremap <leader>mc :make clean<cr><cr>|
nnoremap <leader>md :make<cr>| " make (default)
nnoremap <leader>sop :source %<cr>| " source current file

" NERDTree
nnoremap <leader>nt :NERDTreeToggle<cr>| " NERDTreeToggle

" Presenting (slides start with ">$)
nnoremap <leader>sn nzt|
nnoremap <leader>sp Nzt|
nnoremap <leader>ss /">\$<cr>zt| " Select slide marker

" Refactoring
nmap <leader>rn <Plug>(coc-rename)

" Spelling
nnoremap <leader>sp 1z=

" Tabs
nnoremap <leader><leader>0 10gt
nnoremap <leader><leader>1 1gt
nnoremap <leader><leader>2 2gt
nnoremap <leader><leader>3 3gt
nnoremap <leader><leader>4 4gt
nnoremap <leader><leader>5 5gt
nnoremap <leader><leader>6 6gt
nnoremap <leader><leader>7 7gt
nnoremap <leader><leader>8 8gt
nnoremap <leader><leader>9 9gt
nnoremap <leader>tc :tabc<cr>| " close tab
nnoremap <leader>te :tabe<cr>| " new tab

" Tags
nnoremap <leader>tg :!ctags -R .<cr><leader>| " Silently generate tags

" Terminal
nnoremap <leader>td :bdelete!<cr>| " delete terminal
nnoremap <leader>tt :terminal<cr>| " new terminal
tnoremap <leader><Esc> | " prefer this over plain <Esc> for TUI applications
tnoremap <leader><TAB> | " change to prev buffer

" Toggle
nnoremap <leader>tolw :set wrap!<cr>

" Vundle
nnoremap <leader>vap :call VundleAppendPlugin()<cr>call SortVundlePlugins()<cr>

" Window
nnoremap <leader>0 :exe 10 . "wincmd w"<cr>| " Go to window number 10
nnoremap <leader>1 :exe 1  . "wincmd w"<cr>| " Go to window number 1
nnoremap <leader>2 :exe 2  . "wincmd w"<cr>| " Go to window number 2
nnoremap <leader>3 :exe 3  . "wincmd w"<cr>| " Go to window number 3
nnoremap <leader>4 :exe 4  . "wincmd w"<cr>| " Go to window number 4
nnoremap <leader>5 :exe 5  . "wincmd w"<cr>| " Go to window number 5
nnoremap <leader>6 :exe 6  . "wincmd w"<cr>| " Go to window number 6
nnoremap <leader>7 :exe 7  . "wincmd w"<cr>| " Go to window number 7
nnoremap <leader>8 :exe 8  . "wincmd w"<cr>| " Go to window number 8
nnoremap <leader>9 :exe 9  . "wincmd w"<cr>| " Go to window number 9
nnoremap <leader>w | " Make all window bindings easily available

" leader-end }}}

" Vundle {{{
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'https://github.com/bronson/vim-trailing-whitespace'
"Plugin 'https://github.com/ervandew/supertab'
Plugin 'https://github.com/flazz/vim-colorschemes'
Plugin 'https://github.com/glts/vim-magnum'
Plugin 'https://github.com/JamshedVesuna/vim-markdown-preview'
Plugin 'https://github.com/junegunn/fzf.vim'
Plugin 'https://github.com/kassio/neoterm'
Plugin 'https://github.com/qpkorr/vim-renamer'
Plugin 'https://github.com/rust-lang/rust.vim'
Plugin 'https://github.com/scrooloose/nerdcommenter'
Plugin 'https://github.com/scrooloose/nerdtree'
Plugin 'https://github.com/sickill/vim-pasta'
Plugin 'https://github.com/terryma/vim-multiple-cursors'
Plugin 'https://github.com/theryangeary/take-me-to-your-leader'
Plugin 'https://github.com/tpope/vim-abolish'
Plugin 'https://github.com/tpope/vim-fugitive'
Plugin 'https://github.com/tpope/vim-rhubarb'
Plugin 'https://github.com/tpope/vim-surround'
Plugin 'https://github.com/tpope/vim-unimpaired'
"Plugin 'https://github.com/Valloric/YouCompleteMe'
Plugin 'https://github.com/vim-airline/vim-airline'
Plugin 'https://github.com/vim-airline/vim-airline-themes'
"Plugin 'https://github.com/vim-syntastic/syntastic'
Plugin 'https://github.com/VundleVim/Vundle.vim'
Plugin 'https://github.com/wellle/targets.vim'
Plugin 'https://github.com/neoclide/coc.nvim'
Plugin 'https://github.com/theryangeary/sunset'

call vundle#end()

" }}}

" Post-Vundle stuff {{{
" Config that has to come after Vundle
set termguicolors

" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256


" unicode symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''

syntax enable " enable syntax processing
filetype plugin indent on " load filetype-specific indent files

" Nerdtree config
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" vim-markdown-preview config
let vim_markdown_preview_github=1

let g:sunset_latitude = 40.712776
let g:sunset_longitude = -74.005974
let g:sunset_utc_offset = -4

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" }}}

" Functions {{{

" Set color scheme based on &background
function! SetColorScheme()
  if &background == "dark"
    "colorscheme xoria256
    "colorscheme solarized8_dark
    execute "colorscheme" g:dark_colorscheme
    AirlineTheme dark
  elseif &background == "light"
    execute "colorscheme" g:light_colorscheme
    "colorscheme oceanlight
    AirlineTheme light
  endif
endfunction
command! SetColorScheme :call SetColorScheme()

" Airline statusbar config
function! WindowNumber(...)
  let builder = a:1
  let context = a:2
  call builder.add_section('airline_b', ' %{tabpagewinnr(tabpagenr())} ')
  return 0
endfunction

function! RangedCommand(start, end, command)
  silent! execute a:start . "," . a:end . a:command
endfunction

function! SortVundlePlugins()
  let l:save_view = winsaveview()
  norm gg
  " the 2's are assuming there is a blank line after and begore #begin and #end
  let start_pos = search("vundle\#begin") + 2
  let end_pos = search("vundle\#end") - 2
  " sort in range, case insensitive
  call RangedCommand(start_pos, end_pos, "sort i")
  " restore cursor position
  call winrestview(l:save_view)
endfunction

function! VundleAppendPlugin()
  normal mM
  edit! ~/.vimrc
  set nofoldenable
  execute "normal! gg/^call vundle#end()\<cr>?^Plugin\<cr>yypci'\<C-R>+\<esc>"
  set foldenable
  VundleInstall
  close
  write
  normal! `M
endfunction

" }}}

" Coc.nvim {{{

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.

xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" DISABLED BECAUSE nO YOU CAN'T TAKE MY <C-D> i _NEED_ THAT
"nmap <silent> <C-d> <Plug>(coc-range-select)
"xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}


" }}}

" vim: set fdm=marker:

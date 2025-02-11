" set encoding {{{
set encoding=utf-8
scriptencoding utf-8

" }}}

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
"set inccommand=nosplit
set hlsearch

set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set softtabstop=4

set list
set listchars=tab:\ \ ,extends:❯,precedes:❮
set showbreak=↪

set splitbelow
set splitright

set background=dark
set mouse=a

set completeopt=menu,menuone,noselect
set shortmess+=c

if executable("rg")
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
endif

let &titlestring ='VIM MODE:%{mode()} (%f) %t'
set title

" }}}

" autocommands {{{

"execute "autocmd InsertLeave" g:leader_location ":SortLeaderCommands"

augroup vimrc
  autocmd!
  autocmd InsertLeave * :FixWhitespace " Always strip trailing whitespace

  "autocmd BufWritePre *.py execute ':Isort'
  "autocmd BufWritePre *.py execute ':Black'
  autocmd BufWritePre *.go execute ':GoFmt'

  autocmd FocusLost * :wa
  autocmd WinLeave * :wa

  autocmd VimResized * exe "normal! \<c-w>="

  autocmd VimEnter * :call airline#add_statusline_func('WindowNumber')
  autocmd VimEnter * :call airline#add_inactive_statusline_func('WindowNumber')
  autocmd VimEnter * colorscheme solarized8 | set termguicolors | set bg=light
  autocmd VimEnter * AirlineTheme solarized
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
  "autocmd FileType markdown :nnoremap <cr> :execute "!pandoc -F pandoc-crossref % -o /tmp/out.pdf && open /tmp/out.pdf"<cr>
  "autocmd FileType rust :nnoremap <cr> :!RUST_BACKTRACE=1 cargo run<cr>
  "autocmd FileType rust setlocal makeprg=cargo
  "autocmd FileType rust :nnoremap <cr> :!cargo test<cr>
  "autocmd FileType rust :nnoremap <F2> :!cargo run<cr>
  "autocmd FileType rust :nnoremap <F3> :!RUST_BACKTRACE=1 cargo run<cr>
  "autocmd FileType rust :nnoremap <F4> :!RUST_BACKTRACE=full cargo run<cr>
  "autocmd FileType tex :nnoremap <cr> :execute "!pdflatex % && mupdf" expand('%:t:r') . ".pdf"<cr>
  "autocmd FileType vim :nnoremap <cr> :source %<cr>
  "autocmd FileType python :nnoremap <cr> :!python3 %<cr>
  autocmd FileType json syntax match Comment +\/\/.\+$+
  "autocmd FileType c,cpp :nnoremap <cr> :!gcc % && ./a.out |
  "autocmd FileType hsq :nnoremap <cr> :!hsq %<cr>
  "autocmd FileType html :nnoremap <cr> :!xdg-open %<cr>
  "autocmd FileType java :nnoremap <cr> :!./gradlew installDist<cr>
  "autocmd FileType go :nnoremap <cr> :GoTestFunc<cr>
augroup END

augroup DragQuickfixWindowDown
    autocmd!
    autocmd FileType qf wincmd J
augroup end

" }}}

" basic mappings {{{

" escape is too far
inoremap jk <Esc>
inoremap kj <Esc>

" Use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" }}}

" Vundle {{{
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.fzf
call vundle#begin()


Plugin 'simrat39/rust-tools.nvim'
Plugin 'romainl/vim-qf'
Plugin 'hrsh7th/cmp-nvim-lsp'
Plugin 'hrsh7th/cmp-buffer'
Plugin 'hrsh7th/cmp-path'
Plugin 'hrsh7th/cmp-cmdline'
Plugin 'hrsh7th/nvim-cmp'
Plugin 'hrsh7th/cmp-vsnip'
Plugin 'hrsh7th/vim-vsnip'
Plugin 'golang/vscode-go'

Plugin 'fatih/vim-go'
Plugin 'fisadev/vim-isort'
Plugin 'psf/black'
Plugin 'https://github.com/neovim/nvim-lspconfig'
Plugin 'https://github.com/nvim-lua/lsp_extensions.nvim'
Plugin 'https://github.com/folke/lsp-colors.nvim'
Plugin 'https://github.com/bronson/vim-trailing-whitespace'
Plugin 'https://github.com/junegunn/fzf'
Plugin 'https://github.com/junegunn/fzf.vim'
Plugin 'https://github.com/rust-lang/rust.vim'
Plugin 'https://github.com/scrooloose/nerdcommenter'
Plugin 'https://github.com/scrooloose/nerdtree'
Plugin 'https://github.com/sickill/vim-pasta'
Plugin 'https://github.com/tpope/vim-abolish'
Plugin 'https://github.com/tpope/vim-fugitive'
Plugin 'https://github.com/tpope/vim-rhubarb'
Plugin 'https://github.com/tpope/vim-surround'
Plugin 'https://github.com/tpope/vim-unimpaired'
Plugin 'https://github.com/vim-airline/vim-airline'
Plugin 'https://github.com/vim-airline/vim-airline-themes'
Plugin 'https://github.com/VundleVim/Vundle.vim'
Plugin 'https://github.com/wellle/targets.vim'
Plugin 'https://github.com/morhetz/gruvbox'
Plugin 'https://github.com/lifepillar/vim-solarized8'

call vundle#end()

" }}}

" Post-Vundle stuff {{{
" Config that has to come after Vundle
set termguicolors

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

let g:fzf_layout = {'down': '75%'}

let g:rustfmt_autosave = 1

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_matching_smart_case = 1

let g:deoplete#enable_as_startup = 1

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" }}}

" leader mappings {{{
let g:leader_location = expand("<sfile>:p")

let mapleader = " "
" leader-begin

" Buffers
nnoremap <leader><TAB> | " Go to previous buffer
nnoremap <silent> <leader>bd :bdelete<cr>|
nnoremap <leader>bl :ls<cr>:buffer<space>|

" Debug
nnoremap <leader>dcp :let @+=@%<cr>|
nnoremap <leader>dcl :let @+=@% . ':' . line('.')<cr>|

" Files
nnoremap <leader>fe :edit |
nnoremap <leader>ff :FZF<cr>| " Find file
nnoremap <leader>fr :RG<cr>| " Use rg to find file contents
nnoremap <leader>fs :update<cr>|
nnoremap <leader><leader> :update<cr>|
nnoremap <leader>fve :edit ~/.vimrc<cr>|
nnoremap <leader>fvn :edit ~/.config/nvim/init.vim<cr>|
nnoremap <leader>fvs :source $MYVIMRC<cr>|
nnoremap <leader>qq :q<cr>|

" Fold
nnoremap <leader>fdm :set foldmethod=|
nnoremap <leader>fdms :set foldmethod=syntax<cr>|

" Git (fugitive, rhubarb)
nnoremap <leader>gb V:GBrowse<cr>| " Open current github project in browser
nnoremap <leader>gd :Gdiff<cr>| " Diff current file
nnoremap <leader>gf :Gpull<cr>| " Open fugitive git status buffer
nnoremap <leader>gp :Git push<cr>| " Push project to remote
nnoremap <leader>gs :Git<cr>| " Open fugitive git status buffer

" Go
nnoremap <leader>gotf :GoTestFunc<cr>
nnoremap <leader>goa :GoAlternate<cr>
nnoremap <leader>gor :GoReferrers<cr>

" Make
nnoremap <leader>mb :make build<cr>
nnoremap <leader>mc :make clean<cr><cr>|
nnoremap <leader>md :make<cr>| " make (default)
nnoremap <leader>mm :make |
nnoremap <leader>mr :make run<cr>| " build and run
nnoremap <leader>mt :make test<cr>| " build and run tests
nnoremap <leader>sop :source %<cr>| " source current file

" NERDTree
nnoremap <leader>nt :NERDTreeToggle<cr>| " NERDTreeToggle

" Presenting (slides start with ">$)
nnoremap <leader>sn nzt|
nnoremap <leader>sp Nzt|
nnoremap <leader>ss /">\$<cr>zt| " Select slide marker

" Quickfix
nnoremap <leader>cn :cnext<cr>
nnoremap <leader>cp :cprev<cr>
nnoremap <leader>cc :cclose<cr>
nnoremap <leader>co :copen<cr>

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
nnoremap <leader>wC1 :1close<cr>| " Close window 1 without focusing it
nnoremap <leader>wC2 :2close<cr>| " Close window 2 without focusing it
nnoremap <leader>wC3 :3close<cr>| " Close window 3 without focusing it
nnoremap <leader>wC4 :4close<cr>| " Close window 4 without focusing it
nnoremap <leader>wC5 :5close<cr>| " Close window 5 without focusing it
nnoremap <leader>wC6 :6close<cr>| " Close window 6 without focusing it
nnoremap <leader>wC7 :7close<cr>| " Close window 7 without focusing it
nnoremap <leader>wC8 :8close<cr>| " Close window 8 without focusing it
nnoremap <leader>wC9 :9close<cr>| " Close window 9 without focusing it
nnoremap <leader>wC0 :10close<cr>| " Close window 10 without focusing it

" leader-end }}}

" Functions {{{

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

function! RipgrepFzf(query, fullscreen)
  let cmd_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_cmd = printf(cmd_fmt, shellescape(a:query))
  let reload_cmd = printf(cmd_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_cmd]}
  call fzf#vim#grep(initial_cmd, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" }}}

" GVIM {{{
if has("gui_running")
  " Maximize window on gvim start
  set lines=999 columns=999
endif
" }}}

" vim: set fdm=marker:

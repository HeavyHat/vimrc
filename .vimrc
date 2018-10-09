
execute pathogen#infect()

filetype plugin indent on
syntax on

" Change mapleader
let mapleader=","

" Local dirs
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undodir=~/.vim/undo

set tabstop=4
set expandtab
set autoindent
set shiftwidth=4
set ruler
set colorcolumn=80
set number
set relativenumber
set backspace=indent,eol,start
set visualbell
set mouse+=a
set background=dark 

colorscheme gruvbox

" Uncomment below to make screen not flash on error
" set vb vb_t=""

" NERDTree Config
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

map <C-o> :NERDTreeToggle<CR>

" Airline config
let g:airline_extensions = []

" Syntastic Config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

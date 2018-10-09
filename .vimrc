
execute pathogen#infect()

filetype plugin indent on
syntax on

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

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

map <C-o> :NERDTreeToggle<CR>


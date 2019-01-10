call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-fugitive'
call plug#end()

" Auto install plugins on first launch
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    PlugInstall
endif

let base16colorspace=256
colorscheme base16-ashes

map <C-b> :NERDTreeToggle<CR>

set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4

set list
set colorcolumn=100
set nu

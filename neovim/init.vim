call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'yggdroot/indentline'
Plug 'raimondi/delimitmate'
Plug 'valloric/youcompleteme'
call plug#end()

" Auto install plugins on first launch
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    PlugInstall
endif

" Colo scheme
let base16colorspace=256
colorscheme base16-ashes

" Nerd tree
map <F1> :NERDTreeToggle<CR>

" More natural Tab key
inoremap <S-Tab> <C-d>
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Navigation in insert mode using Alt key
inoremap <silent> <M-h> <Left>
inoremap <silent> <M-j> <Down>
inoremap <silent> <M-k> <Up>
inoremap <silent> <M-l> <Right>

" Editor display settings
set list
set colorcolumn=100
set number relativenumber
set nu rnu

" Mouse settings
set mouse=a

" Indent settings
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4

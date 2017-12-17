" -----------------------------------------------------------------------------
"  < Plugins >
" -----------------------------------------------------------------------------
" use vundle manage plugins

"set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim


"call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
call vundle#begin('~/.config/nvim/bundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'




"Plugin 'tpope/vim-fugitive'
"Plugin 'L9'
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"" Plugin 'FromtonRouge/OmniCppComplete'
"" Plugin 'Lokaltog/vim-powerline'
""Plugin 'Shougo/neocomplete.vim'
""Plugin 'Yggdroot/indentLine'  "low speed for scrolling
"Plugin 'Align'
"Plugin 'Shougo/neocomplcache'
"Plugin 'TxtBrowser'
"Plugin 'ZoomWin'
"Plugin 'a.vim'
"Plugin 'bufexplorer.zip'
"Plugin 'ccvext.vim'
"Plugin 'ctrlp.vim'
"Plugin 'christoomey/vim-tmux-navigator'
Plugin 'easymotion/vim-easymotion'
"Plugin 'ervandew/supertab'
Plugin 'jiangmiao/auto-pairs'
"Plugin 'majutsushi/tagbar'
"" Plugin 'minibufexpl.vim'
"Plugin 'msanders/snipmate.vim'
"Plugin 'repeat.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
"Plugin 'scrooloose/syntastic'
"Plugin 'std_c.zip'
"Plugin 'taglist.vim'
Plugin 'tpope/vim-surround'
Plugin 'vim-airline/vim-airline'
"Plugin 'vim-scripts/Mark--Karkat'
"Plugin 'vim-scripts/cSyntaxAfter'
"Plugin 'wesleyche/SrcExpl'
"Plugin 'winmanager'


"Keep Plugin commands between vundle#begin/end.
call vundle#end()            " required


" -----------------------------------------------------------------------------
"  < Options >
" -----------------------------------------------------------------------------
"  
set termguicolors
colorscheme Tomorrow-Night-Eighties


filetype on                                     "启用文件类型侦测
filetype plugin on                              "针对不同的文件类型加载对应的插件
filetype plugin indent on                       "启用缩进

set smartindent                                 "启用智能对齐方式
set expandtab                                   "将Tab键转换为空格
set tabstop=4                                   "设置Tab键的宽度
set shiftwidth=4                                "换行时自动缩进4个空格
set smarttab                                    "指定按一次backspace就删除shiftwidth宽度的空格
set foldenable                                  "启用折叠
set foldmethod=indent                           "indent 折叠方式

"" set foldmethod=manual                           "manual 折叠方式
""set foldmethod=marker                        "marker 折叠方式
"set foldopen=all                                "auto open fold
"set foldclose=all                               "auto close fold


"" 当文件在外部被修改，自动更新该文件
set autoread


set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
"" set noincsearch                                       "在输入要搜索的文字时，取消实时匹配
"set hlsearch        "高亮搜索
"set incsearch       "在输入要搜索的文字时，实时匹配

"set clipboard=unnamed

set showcmd

set number                                            "显示行号
" set relativenumber
"set laststatus=2                                      "启用状态栏信息
"set cmdheight=2                                       "设置命令行的高度为2，默认为1
"set cursorline                                        "突出显示当前行
"set cursorcolumn                                       "突出显示当前行
"set textwidth=80 "can use gq to format
"if g:iswindows
    "set guifont=Source_Code_Pro:h11
    "" set guifont=YaHei_Consolas_Hybrid:h10                 "设置字体:字号（字体名称空格用下划线代替）
"else
    "set guifont=DejaVu\ Sans\ mono\ 11
    "" set guifont=Ubuntu\ 11                           "设置字体:字号（字体名称空格用下划线代替）
    "" set guifont=SourceCodePro\ 11                           "设置字体:字号（字体名称空格用下划线代替）
"endif

set nowrap                                            "设置不自动换行
"set shortmess=atI                                     "去掉欢迎界面
"" au GUIEnter * simalt ~x                              "窗口启动时自动最大化

"winpos 0 0                                         "指定窗口出现的位置，坐标原点在屏幕左上角
"" set lines=80 columns=118                              "指定窗口大小，lines为高度，columns为宽度
"set lines=500 columns=500                              "指定窗口大小，lines为高度，columns为宽度

"" -----------------------------------------------------------------------------
""  < 其它配置 >
"" -----------------------------------------------------------------------------
"set history=50		" keep 50 lines of command line history

"set writebackup                             "保存文件前建立备份，保存成功后删除该备份
"set nobackup                                "设置无备份文件
"" set noswapfile                              "设置无临时文件
"set vb t_vb=                                "关闭提示音

" cursor
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" -----------------------------------------------------------------------------
"  < Key Mappings >
" -----------------------------------------------------------------------------
let mapleader = "\<Space>"

imap jj <Esc>
"map ; :


" terminal emulator
tnoremap <Esc> <C-\><C-n>

tnoremap <Leader>h <C-\><C-n><C-w>h
tnoremap <Leader>j <C-\><C-n><C-w>j
tnoremap <Leader>k <C-\><C-n><C-w>k
tnoremap <Leader>l <C-\><C-n><C-w>l


" "; 
nnoremap <Leader>; A;<Esc>

" "E 
nnoremap <Leader>e :update<CR>:!make<CR>

" "G 
nnoremap <Leader>g :vimgrep // *.*<left><left><left><left><left>

" window
" "H 
nnoremap <Leader>h <C-w>h
" "I 
nnoremap <Leader>j <C-w>j
" "J 
nnoremap <Leader>k <C-w>k
" "K 
nnoremap <Leader>l <C-w>l

" "Q
nnoremap <Leader>q <Esc>:q<CR>

" "R
nnoremap <Leader>r :!./out<CR>


" "S
" nnoremap <Leader>s :update<CR>
nnoremap <Leader>ss :%s/\s\+$//ge<cr>:noh<cr>

" "T
nnoremap <Leader>t :update<CR>:!./%<CR>
" "W
nnoremap <Leader>w <Esc>:w<CR>
" "X
nnoremap <Leader>x :xa<CR>



" " 用空格键来开关折叠
" " nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
" nnoremap <Leader>, @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
"nnoremap <Leader>; A;<Esc>
" nnoremap <Leader>ss :%s/\s\+$//ge<cr>:noh<cr>
" nnoremap <Leader>sm :%s/\r$//g<cr>:noh<cr>
" inoremap <Leader>s <Esc>:w<cr>
" nnoremap <Leader>s :w<cr>
" nnoremap <Leader>q :q<cr>
" nnoremap <Leader>sw :set wrap<cr>
" " leader g for vimgrep
" " semicolon to colon in normal mode to fast type command
" " nmap ; :
" 
" 
" 
" " F3
nnoremap <F3> <C-W><C-V><C-W>lgf
" nnoremap <F9> :SyntasticToggleMode<CR>
" " F4 compile
" nnoremap <F4> :update<CR>:!make<CR>
" inoremap <F4> <Esc>:update<CR>:!make<CR>
" " F5 run previous command
" nnoremap <F5> :!./out<CR>
" inoremap <F5> <Esc>:!./out<CR>
" 
" 
" inoremap <F7> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
" nnoremap <F7> <Esc>[I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
" 
" nnoremap <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
" inoremap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>

" "L 

" nnoremap <C-s> :update<CR>
" inoremap <C-s> <Esc>:update<CR>
" vnoremap <C-s> <Esc>:update<CR>
" nnoremap <C-S> :update<CR>
" inoremap <C-S> <Esc>:update<CR>
" vnoremap <C-S> <Esc>:update<CR>
" 

inoremap <C-A> <Esc>I
inoremap <C-E> <Esc>A
inoremap <C-F> <Right>
inoremap <C-B> <Left>

nnoremap <C-U> <C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>
nnoremap <C-D> <C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>


" " " A
" 
" " " B
" nnoremap <A-b> :update<cr>:!g++ -std=c++11 % -o out<cr>
" nnoremap <A-B> :update<cr>:!g++ -std=c++11 % -o out<cr>
" 
" " " C
" " copy to clipboard
" inoremap <A-c> <Esc>"+yy
" nnoremap <A-c> <Esc>"+yy
" vnoremap <A-c> "+y
" inoremap <A-C> <Esc>"+yy
" nnoremap <A-C> <Esc>"+yy
" vnoremap <A-C> "+y
" 
" " " D
 " sublime ctrl+shift+k
 nnoremap <A-d> dd
 nnoremap <A-D> ddk
 inoremap <A-d> <C-O>dd
 inoremap <A-D> <C-O>ddk
 vnoremap <A-d> d
 vnoremap <A-D> dk
" 
" " " E
" 
" " " F
" 
" " " G
" 
" " H
"inoremap <A-h> <Left>
"nnoremap <A-h> 

" " J
"inoremap <A-j> <Down>
"nnoremap <A-j> ddp
"vnoremap <A-j> <Esc>`>jdd`<Pgv
"vnoremap <A-J> <Esc>`>jdd`<Pgv
nnoremap <A-j> o<Esc>k
inoremap <A-j> <Esc>o

" " K
nnoremap <A-k> O<Esc>
inoremap <A-k> <Esc>O
"inoremap <A-k> <Up>
"nnoremap <A-k> kddpk
"vnoremap <A-k> <Esc>`<kdd`>pgv
"vnoremap <A-K> ykddgv<Esc>pgv
 
 " " L
"inoremap <A-l> <Right>
 "nnoremap <A-l> 
" 
" " " M
" " sublime ctrl+l
" nnoremap <A-m> V
" nnoremap <A-M> V
" vnoremap <A-m> j
" vnoremap <A-M> k
" 
" " " N
" 
" " " O
" tmux occupy
"nnoremap <A-m> o<Esc>k
"nnoremap <A-M> O<Esc>
"inoremap <A-m> <Esc>o
"inoremap <A-M> <Esc>O
"
 " " P
" autopair plugin occupy 

" " " Q
map <A-q> <Esc>:q<CR>

" " S
map <A-s> <Esc>:update<CR>
" 
" " " T
" 
" " " U
" inoremap <A-u> <Esc>ui
" inoremap <A-U> <Esc>ui
" 
" " " V
  " paste from clipboard
" inoremap <A-v> <Esc>"+p
" nnoremap <A-v> <Esc>"+p
" vnoremap <A-v> "+p
" inoremap <A-V> <Esc>"+p
" nnoremap <A-V> <Esc>"+p
" vnoremap <A-V> "+p
" 
" " " W
" 
" " " X
" noremap <A-x> i<space><Esc>
" 
" " " Y
" " sublime ctrl+shift+d
 nnoremap <A-y> yyp
 nnoremap <A-Y> yyP
 vnoremap <A-y> y`>p
 vnoremap <A-Y> y`<P
 inoremap <A-y> <C-O>yyp
 inoremap <A-Y> <C-O>yyP
" 
" " " Z
" 
" 
" 
" 
" 至行首
cnoremap <C-A>		<Home>
" 后退一个字符
cnoremap <C-B>		<Left>
" 删除光标所在的字符
cnoremap <C-D>		<Del>
" 至行尾
cnoremap <C-E>		<End>
" 前进一个字符
cnoremap <C-F>		<Right>
" 取回较新的命令行
cnoremap <C-N>		<Down>
" 取回以前 (较旧的) 命令行
cnoremap <C-P>		<Up>
" 后退一个单词
"cnoremap <A-b>	<S-Left>
" 前进一个单词
"cnoremap <A-F>	<S-Right>
" 
" 
" iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
iab xdate <c-r>=strftime("%m/%d/%y")<cr>
iab endl << endl
iab cout cout <<
iab cin cin >>
iab #i #include

" vim:fdm=marker
"                    << Global Variable >> {{{1
 " < Windows or Linux > {{{2
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:iswindows = 0
endif
" }}}2
"  < GUI or Terminal > {{{2
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif
" }}}2
" < Distro > {{{2
" let g:distro = 'ubuntu'
" let g:distro = 'others'
" }}}2
" }}}1
"                       << Default Configuration >> {{{1


"  < Should not change options > {{{2

set nocompatible

" }}}2
"  < GUI User Interface > {{{2

if g:isGUI
    " let &statusline=' %t %{&mod?(&ro?"*":"+"):(&ro?"=":" ")} %1*|%* %{&ft==""?"any":&ft} %1*|%* %{&ff} %1*|%* %{(&fenc=="")?&enc:&fenc}%{(&bomb?",BOM":"")} %1*|%* %=%1*|%* 0x%B %1*|%* (%l,%c%V) %1*|%* %L %1*|%* %P'
    " set statusline=%t\ %1*%m%*\ %1*%r%*\ %2*%h%*%w%=%l%3*/%L(%p%%)%*,%c%V]\ [%b:0x%B]\ [%{&ft==''?'TEXT':toupper(&ft)},%{toupper(&ff)},%{toupper(&fenc!=''?&fenc:&enc)}%{&bomb?',BOM':''}%{&eol?'':',NOEOL'}]

    " For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
    " let &guioptions = substitute(&guioptions, "t", "", "g")
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    map <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
                \set guioptions-=m <Bar>
                \set guioptions-=T <Bar>
                \set guioptions-=r <Bar>
                \set guioptions-=L <Bar>
                \else <Bar>
                \set guioptions+=m <Bar>
                \set guioptions+=T <Bar>
                \set guioptions+=r <Bar>
                \set guioptions+=L <Bar>
                \endif<CR>


endif


" }}}2
"  < Windows Gvim > {{{2

if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set diffexpr=MyDiff()

    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    "解决consle输出乱码
    language messages zh_CN.utf-8

    map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>

    function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif


" }}}2
"  < Linux Gvim/Vim > {{{2

if !g:iswindows

    if g:isGUI

    else
        " very important can not change10/11/16
        set term=screen-256color
        " terminal option : number of colors
        set t_Co=256
        " terminal option : clearing uses the current background color
        set t_ut=

        " if has("lua") || has("mac")
            " let &t_SI = "\e[5 q"
            " let &t_EI = "\e[2 q"
        " endif
    endif
endif

" }}}2
" }}}1
"                          << Auto Cmd >> {{{1
" Uncomment the following to have Vim jump to the last position when
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" toggle folder off when open file
" au BufRead * normal zi
" auto change dir to current file but conflict with fugitive
" au BufRead,BufNewFile,BufEnter * cd %:p:h

" au InsertEnter,VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
" au InsertLeave,VimEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"

if has("autocmd")
    au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
    au InsertEnter,InsertChange *
                \ if v:insertmode == 'i' | 
                \   silent execute '!echo -ne "\e[6 q"' | redraw! |
                \ elseif v:insertmode == 'r' |
                \   silent execute '!echo -ne "\e[4 q"' | redraw! |
                \ endif
    au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif
" }}}1
"                          << User functions >> {{{1
function! s:ExecuteInShell(command)
    let command = join(map(split(a:command), 'expand(v:val)'))
    " let winnr = bufwinnr('^' . command . '$')
    let winnr = bufwinnr('^' . "command" . '$')
    " silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
    silent! execute  winnr < 0 ? 'botright new ' . "command" : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number nofoldenable
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! execute 'resize ' . line('$')
    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
    silent! execute "wincmd k"
    echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ S call s:ExecuteInShell(<q-args>)

" }}}1
"                          << User Options >> {{{1
"  < Appearance Options > {{{2

" ------------ colorscheme
if g:isGUI
    colorscheme Tomorrow-Night-Eighties
    " colorscheme base16-flat
    " colorscheme molokai
else
    " set background=light
    " colorscheme solarized
    colorscheme Tomorrow-Night-Eighties
    " let base16colorspace=256  " Access colors present in 256 colorspace
    " colorscheme base16-flat
    " colorscheme molokai
    " let g:rehash256=1
endif

" ------------ font
if g:iswindows
    " set guifont=Source_Code_Pro:h11
    " set guifont=YaHei_Consolas_Hybrid:h10
else
    if g:isGUI
        " set guifont=BitstreamVeraSansMono\ 10.5
        if has("lua")

        else
            if has("mac")
                " set guifont=Source\ Code\ Pro:h16
            else
                " set guifont=BitstreamVeraSansMono\ 11
            endif
        endif
    endif
endif

" dictionary
set dictionary+=/usr/share/dict/words
set complete+=k
set completeopt=menu
" ------------ mouse
" can not use in mac and redhat
" set mouse=a
" ------------ signs
set showcmd
set wildmenu
" set colorcolumn=80

set number
set relativenumber
set laststatus=2
set cmdheight=2
set cursorline
set cursorcolumn
set splitbelow
set splitright

" ------------ scroll
set scrolloff=5
set scrollopt+=hor

set nowrap
set shortmess=atI
if has("lua")
    winpos 0 0
    set lines=500 columns=500
else
    winpos 1250 0
    set lines=80 columns=100
endif

if executable('goldendict')
    set keywordprg=goldendict
endif 
" }}}2
"  < Encoding Options > {{{2

if has("multi_byte")
    if &termencoding == ""
        let &termencoding=&encoding
    endif
    " set termencoding=utf-8
    set encoding=utf-8
    setglobal fileencoding=utf-8
    " setglobal bomb
    " set fileencodings=ucs-bom,utf-8,gb2312,gbk,gb18030
    set fileencodings=utf-8,gb2312,gbk,gb18030
endif


" }}}2
"  < Edit Options > {{{2


" ------------ file type & indent

" command                        detection    plugin        indent ~
" :filetype on                   on           unchanged     unchanged
" :filetype off                  off          unchanged     unchanged
" :filetype plugin on            on           on            unchanged
" :filetype plugin off           unchanged    off           unchanged
" :filetype indent on            on           unchanged     on
" :filetype indent off           unchanged    unchanged     off
" :filetype plugin indent on     on           on            on
" :filetype plugin indent off    unchanged    off           off

filetype on
filetype plugin on
filetype plugin indent on
" usually when use smartindent should set autoindent
set autoindent
set smartindent

set virtualedit=block
" ------------ buffer
set hidden

" ------------ syntax
syntax on

" ------------ fold
set foldenable
set foldmethod=indent
" set foldmethod=manual
" set foldmethod=marker
set foldlevel=99
"
" ------------ tab
set expandtab
set tabstop=4
set shiftwidth=4
set smarttab

" ------------ backspace
" equal to :set backspace=indent,eol,start
set backspace=2



" ------------ search
set hlsearch
set incsearch
" set noincsearch
set ignorecase
set smartcase

" ------------ find & replace
set magic

" ------------ copy & paste
set clipboard=unnamed


" ------------ file save and backup
set autoread

if has("mac")
    set fileformat=mac
    set fileformats=mac,unix,dos
else
    set fileformat=unix
    set fileformats=unix,dos,mac
endif

"  'backup' 'writebackup'	action	~
"     off	     off	no backup made
"     off	     on		backup current file, deleted afterwards (default)
"     on	     off	delete old backup, backup current file
"     on	     on		delete old backup, backup current file
set nobackup
set writebackup
" set noswapfile



" }}}2
"  < Other Options > {{{2

set history=50        " keep 50 lines of command line history

set vb t_vb=

" }}}2
"                         << ------------ Key Mapping Begin>> {{{1
" }}}1
"  < Abbr Mapping > {{{1

func Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
" iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
iab xdate <c-r>=strftime("%m/%d/%y")<cr>
" iab endl << endl
iab cout cout <<
iab cin cin >>
iab #i #include
iab teh the
iabbr <silent> s self<C-R>=Eatchar('\s')<CR>
iabbr <silent> sd self.<C-R>=Eatchar('\s')<CR>
iabbr <silent> sc self,<C-R>=Eatchar('\s')<CR>
iabbr <silent> se self<C-R>=Eatchar('\s')<CR><C-R>=pyer#smartcolon#insert()<CR><C-R>=Eatchar('\s')<CR>
iabbr <silent> r return
imap , ,<space>


" }}}1
"  < Leader Key Mapping > {{{1


" let mapleader = "'"
" let maplocalleader = "-"
" map <Space> <Leader>
" let mapleader = "\<Space>"
" nnoremap <Space> :

map <Space><Space> <Plug>NERDCommenterToggle

" map <Space>a A;<Esc>
" "'
nnoremap <Leader>' ''
" ";
" nnoremap <Leader>; A;<Esc>
" inoremap <Leader>; <Esc>A;<Esc>

nnoremap <Space>; q:k

" "A;
" vnoremap a :EasyAlign<CR>
vnoremap <Space>a= :EasyAlign<CR>*<Right>=<CR>
vnoremap <Space>a, :EasyAlign<CR>*<Right>,<CR>
vnoremap <Space>a: :EasyAlign<CR>*<Right>:<CR>


" "B
" nnoremap <Leader>b :update<CR>:!make<CR>
" "E
if findfile("Makefile") == "Makefile"
    if g:isGUI
        nnoremap <Leader>e :update<CR>:!make && ./out<CR>
        " nnoremap <Space>e :update<CR>:!make && ./out<CR>
    else
        nnoremap <Leader>e :update<CR>:S make && ./out<CR>
        " nnoremap <Space>e :update<CR>:S make && ./out<CR>
    endif
else
    " todo how to run in shell use % 10/16/16
    if g:isGUI
        nnoremap <Leader>e :update<CR>:!./%<CR>
        " nnoremap <Space>e :update<CR>:!./%<CR>
    else
        nnoremap <Leader>e :update<CR>:S ./*.pl*<CR>
        " nnoremap <Space>e :update<CR>:S ./*.pl*<CR>
    endif
endif
" nnoremap <Leader>e :update<CR>:!make<CR>

" "G
" nnoremap <Leader>g :vimgrep // *.*<left><left><left><left><left>
" nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ."<cr> :copen<cr>
" " window
" "H
nnoremap <Leader>h <C-w>h
" "I
nnoremap <Leader>j <C-w>j
" "J
nnoremap <Leader>k <C-w>k
" "K
nnoremap <Leader>l <C-w>l

" "Q
nnoremap <Leader>q <Esc>:bd<CR>
nnoremap <Space>q <Esc>:q<CR>

" "R
" "conflict with Mark--Karkat <Leader> m n r *
" below add in .vim/after/unmap.vim
" unmap <Leader>r
" nnoremap <Leader>r :!./out<CR>
" /

" "S
" <leader>s use google search words selected
" split and diff with previous version
nnoremap <Space>sb :windo set scrollbind!<CR> 
nnoremap <Space>scl :windo set cursorline!<CR> 
nnoremap <Space>scb :windo set cursorbind!<CR> 
nnoremap <Space>sl :vs<CR>:silent Glog<CR>:cnext<CR>:windo diffthis<CR>
nnoremap <Space>sd :windo diffthis<CR>
nnoremap <Space>so :windo diffoff<CR> 
nnoremap <Space>su :windo diffu<CR> 
nnoremap <Space>sr :windo set relativenumber!<CR> 
nnoremap <Space>ss :s/\s\+$//ge<cr>:nohl<cr>
nnoremap <Space>sp :set spell!<CR>
" nnoremap <Space>sl :redraw!<CR>
" nnoremap <Space>so :source $MYVIMRC<CR>:AirlineRefresh<CR>
nnoremap <Space>sy :!ctags -R *<CR>
nnoremap <Space><Enter> <C-]>
nnoremap <Space>h :po<CR>
nnoremap <Space>l :tag<CR>
" nnoremap <Space>s :tselect<CR>

" "T
" nnoremap <Space>t :NERDTreeToggle<CR>
nnoremap <F3> :NERDTreeToggle<CR>
inoremap <F3> <Esc>:NERDTreeToggle<CR>
" V
" nnoremap <Space>v :e ~/.vimrc<CR>
" "W
nnoremap <Leader>w <Esc>:wq<CR>
" "X
nnoremap <Leader>x :xa<CR>
nnoremap <Space>x :xa<CR>


" }}}1
"  < Normal Key Mapping > {{{1

" Don't use Ex mode, use Q for formatting
" map Q gq
" ";
" jj or jk 插入模式下go to normal mode
" inoremap kj <Esc>
inoremap jj <Esc>
" inoremap kk <Esc>yyp
inoremap jk <Right>
" , always followed by a space
" inoremap , ,<Space>
inoremap z, ,
inoremap z: :
inoremap zs s
inoremap zr r
inoremap z= =
nnoremap <BS> <C-^>


map Y y$
map 0 ^
" Type 12<Enter> to go to line 12 (12G breaks my wrist)
" Hit Enter to go to end of file.
" Hit Backspace to go to beginning of file.
" nnoremap <CR> G
" nnoremap <BS> gg

" Quickly select text you just pasted:
noremap gV `[v`]
"dgn is easy to use
vnoremap < <gv
vnoremap > >gv

" }}}1
"  < Function Key Mapping > {{{1


" F2
" for NerdTree
" F3
" for xxx
" F4 compile
nnoremap <F4> :update<CR>:!make<CR>
inoremap <F4> <Esc>:update<CR>:!make<CR>
" F5 run previous command
nnoremap <F5> :!./out<CR>
inoremap <F5> <Esc>:!./out<CR>

nnoremap <F6> :update<CR>:!./%<CR>
inoremap <F6> <Esc>:update<CR>:!./%<CR>

inoremap <F7> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
nnoremap <F7> <Esc>[I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

nnoremap <F12> :SyntasticToggleMode<CR>

nnoremap <F11> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
inoremap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>


" }}}1
"  < Ctrl Key Mapping > {{{1

cnoremap <C-A>        <Home>
cnoremap <C-B>        <Left>
cnoremap <C-D>        <Del>
inoremap <C-d>        """"""<left><left><left>
cnoremap <C-E>        <End>
cnoremap <C-F>        <Right>
cnoremap <C-N>        <Down>
cnoremap <C-P>        <Up>
"cnoremap <A-b>    <S-Left>
"cnoremap <A-F>    <S-Right>


" }}}1
"  < Shift Key Mapping > {{{1

"  shift keys ---------------------------------------------------------
" in konsole it is used to shift termianl tabs
" map <S-Left> :tabp<CR>
" map <S-Right> :tabn<CR>



" }}}1
"  < Alt Key Mapping > {{{1

"  Alt keys ---------------------------------------------------------
if !  g:isGUI
    let c='a'
    while c <= 'z'
        exec "set <A-".c.">=\e".c
        exec "imap \e".c." <A-".c.">"
        let c = nr2char(1+char2nr(c))
    endw

    let C='A'
    while C <= 'Z'
        exec "set <A-".C.">=\e".C
        exec "imap \e".C." <A-".C.">"
        let C = nr2char(1+char2nr(C))
    endw

    set timeout ttimeoutlen=50
endif
" " " A-A
" map <A-a> <Plug>NERDCommenterToggle
nnoremap <A-a> A:<CR>
" inoremap <A-a> <Esc>A:<CR>
" nnoremap <A-a> A;
" inoremap <A-a> <Esc>A;

" " " A-B
" nnoremap <A-b> :update<CR>:!make<CR>
" nnoremap <A-B> :update<CR>:!make<CR>
"
" " " A-C
" " copy to clipboard
" inoremap <A-c> <Esc>"+yy
" nnoremap <A-c> <Esc>"+yy
" vnoremap <A-c> "+y
" inoremap <A-C> <Esc>"+yy
" nnoremap <A-C> <Esc>"+yy
" vnoremap <A-C> "+y
inoremap <A-c> <Esc>o<Esc>i<CR>class 
nnoremap <A-c> <Esc>o<Esc>i<CR>class 

"
" " " A-D
" sublime ctrl+shift+k
nnoremap <A-d> "_dd
nnoremap <A-D> "_ddk
inoremap <A-d> <C-O>"_dd
inoremap <A-D> <C-O>"_ddk
vnoremap <A-d> "_d
vnoremap <A-D> "_dk
"
" " " A-E
"auto-pair occupy

" " " A-F
" nnoremap <A-f> :vs<cr>gf<cr>
" inoremap <A-f> <Esc>o<Esc>ki<Down><CR><Tab>def 
" nnoremap <A-f> <Esc>o<Esc>ki<Down><CR><Tab>def 
inoremap <A-f> <Esc>o<Esc>i<CR><Tab>def 
nnoremap <A-f> <Esc>o<Esc>i<CR><Tab>def 

" " " A-G
function! HasReturnOrPass()
    let line = getline('.')
    if line =~ '^\s*\(return\|pass\)\s'
        return "\<CR>"
    else
        return "\<Esc>o\<BS>"
    end
endfunction


inoremap <expr> <A-g> HasReturnOrPass()

" " A-H
inoremap <A-h> <Left>
"nnoremap <A-h>

" " A-I
" inoremap <A-i> <Right>:<CR>def<Space>__init__(self, )<Left>

" " A-J
"inoremap <A-j> <Down>
"nnoremap <A-j> ddp
"vnoremap <A-j> <Esc>`>jdd`<Pgv
"vnoremap <A-J> <Esc>`>jdd`<Pgv
" nnoremap <A-j> o<Esc>k
" inoremap <A-j> <Esc>A<CR>
function! IsEmptyLine()
    let line = getline('.')
    if line =~ '^\s*$'
        return "\<CR>"
    else
        return "\<Esc>o"
    end
endfunction

inoremap <expr> <A-j> IsEmptyLine()
    
" " A-K
" nnoremap <A-k> O<Esc>
inoremap <A-k> <Esc>O
"inoremap <A-k> <Up>
"nnoremap <A-k> kddpk
"vnoremap <A-k> <Esc>`<kdd`>pgv
"vnoremap <A-K> ykddgv<Esc>pgv

" " A-L
"inoremap <A-l> <Right>
"nnoremap <A-l>
" inoremap <silent> <A-l> <Esc>:call AutoPairsJump()<CR>a
"
" " " A-M
" " sublime ctrl+l
" inoremap <A-m> <Esc>A<CR><CR><C-h>def 
" nnoremap <A-m> A<CR><CR><C-h>def 
" nnoremap <A-m> V
" nnoremap <A-M> V
" vnoremap <A-m> j
" vnoremap <A-M> k
"
" " " A-N
"  Autopair occupy
" inoremap <A-n> <CR><BS>

" " " A-O
" tmux occupy
if !exists('$TMUX')
    nnoremap <A-o> o<Esc>k
    nnoremap <A-O> O<Esc>
    inoremap <A-o> <Esc>o
    inoremap <A-O> <Esc>O
endif
"
" " A-P
" autopair plugin occupy


" " " A-Q
" map <A-q> <Esc>:q<CR>
nnoremap <A-q> :q<CR>
inoremap <A-q> <Esc>:q<CR>
vnoremap <A-q> <Esc>:q<CR>
nnoremap <A-Q> :q<CR>
inoremap <A-Q> <Esc>:q<CR>
vnoremap <A-Q> <Esc>:q<CR>

" " A-R
" nnoremap <A-r> :update<CR>:!python %<CR>
" inoremap <A-r> <Esc>:update<CR>:!python %<CR>
" vnoremap <A-r> <Esc>:!python %<CR>

" " A-S
" map <A-s> <Esc>:update<CR>
nnoremap <A-s> :update<CR>
inoremap <A-s> <Esc>:update<CR>
vnoremap <A-s> <Esc>:update<CR>
nnoremap <A-S> :update<CR>
inoremap <A-S> <Esc>:update<CR>
vnoremap <A-S> <Esc>:update<CR>
"
" " " A-T
" map <A-T> :!./out<CR>
" map <A-t> :!./out<CR>
"
" " " A-U
" inoremap <A-u> <Esc>ui
" inoremap <A-U> <Esc>ui
"
" " " A-V
nnoremap <A-v> :e ~/.vimrc<CR>
" paste from clipboard
" inoremap <A-v> <Esc>"+p
" nnoremap <A-v> <Esc>"+p
" vnoremap <A-v> "+p
" inoremap <A-V> <Esc>"+p
" nnoremap <A-V> <Esc>"+p
" vnoremap <A-V> "+p
"
" " " A-W
nnoremap <A-w> :wq<CR>
inoremap <A-w> <Esc>:wq<CR>
vnoremap <A-w> <Esc>:wq<CR>
nnoremap <A-W> :wq<CR>
inoremap <A-W> <Esc>:wq<CR>
vnoremap <A-W> <Esc>:wq<CR>
"
" " " A-X
nnoremap <A-x> :xa<CR>
inoremap <A-x> <Esc>:xa<CR>
"
" " " A-Y
" " sublime ctrl+shift+d
nnoremap <A-y> yyp
nnoremap <A-Y> yyP
vnoremap <A-y> y`>p
vnoremap <A-Y> y`<P
" inoremap <A-y> <C-O>yyp
" inoremap <A-Y> <C-O>yyP
inoremap <A-y> <Esc>yyp
inoremap <A-Y> <Esc>yyP

" " " A-Z

" }}}1
"                         << ------------ Key Mapping End >> {{{1
" }}}1
"                    << Work With Other Tools >> {{{1
"  < tmux > {{{2

if exists('$TMUX')
    function! TmuxOrSplitSwitch(wincmd, tmuxdir)
        let previous_winnr = winnr()
        silent! execute "wincmd " . a:wincmd
        if previous_winnr == winnr()
            call system("tmux select-pane -" . a:tmuxdir)
            redraw!
        endif
    endfunction

    let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
    let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
    let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

    " for cursor sharp
    " if has("lua") || has("mac")
        " let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
        " let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
    " endif
    " Konsole
    " let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    " let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    " let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"

    nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
    nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
    nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
    nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
    " Konsole
    " let &t_SI="\<Esc>]50;CursorShape=1\x7"
    " let &t_SR="\<Esc>]50;CursorShape=2\x7"
    " let &t_EI="\<Esc>]50;CursorShape=0\x7"

    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l
endif

" }}}2
"  < cscope > {{{2

if has("cscope")
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    set cscopetag
    set csto=0
    if filereadable("cscope.out")
        cs add cscope.out
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set cscopeverbose
    "快捷键设置
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif


" }}}2
"  < ctags > {{{2

set tags=./tags,tags;$HOME



" }}}2
"  < others > {{{2
" }}}2
" }}}1
"             << ------------ Plug Begin >> {{{1
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" filetype off

" " for Vundle
" if !g:iswindows
"     set rtp+=~/.vim/bundle/Vundle.vim
"     call vundle#begin()
" else
"     set rtp+=$VIM/vimfiles/bundle/vundle.vim/
"     call vundle#begin('$VIM/vimfiles/bundle/')
" endif
" set the runtime path to include Vundle and initialize
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" " let Vundle manage Vundle, required
" Plugin 'VundleVim/Vundle.vim'
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" }}}1
"  < vim-fugitive > {{{1

Plug 'tpope/vim-fugitive'
" fugitive git bindings

nnoremap <space>ga :Git add %:p<CR><CR>
nnoremap <Space>gb :Gblame<CR>
" nnoremap <space>gb :Git branch<Space>
nnoremap <space>gc :Gcommit -v -q<CR>
nnoremap <Space>gd :Gdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gm :Gmove<Space>
nnoremap <space>go :Git checkout<Space>
nnoremap <space>gps :Dispatch! git push<CR>
nnoremap <space>gpl :Dispatch! git pull<CR>
nnoremap <Space>gs :Gstatus<CR>
nnoremap <space>gt :Gcommit -v -q %:p<CR>
" nnoremap <space>gL :exe ':!cd ' . expand('%:p:h') . '; git la'<CR>
" nnoremap <space>gl :exe ':!cd ' . expand('%:p:h') . '; git las'<CR>
" nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <space>gl :silent Glog<CR>
nnoremap <space>gL :silent Glog<CR>:set nofoldenable<CR>
nnoremap <space>gr :Gread<CR>
nnoremap <space>gw :Gwrite<CR>
" nnoremap <space>gw :Gwrite<CR><CR>
nnoremap <space>gp :Git push<CR>
" nnoremap <space>gp :Ggrep<Space>
nnoremap <space>g- :Silent Git stash<CR>:e<CR>
nnoremap <space>g+ :Silent Git stash pop<CR>:e<CR>


" }}}1
"  < vim-grep-operator > {{{1
Plug 'ykwoshia/vim-grep-operator'
" }}}1
"  < unimpaired.vim > {{{1
Plug 'tpope/vim-unimpaired'
" }}}1
"  < junegunn/gv.vim > {{{1
Plug 'junegunn/gv.vim'
" }}}1
" < L9 > {{{1
Plug 'vim-scripts/L9'
" }}}1
" < LineJuggler > {{{1
Plug 'vim-scripts/LineJuggler'
" }}}1
" < ingo-library > {{{1
Plug 'inkarkat/vim-ingo-library'
" }}}1
"  < Align > {{{1
Plug 'vim-scripts/Align'
Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}}1
"  < fzf > {{{1
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
" Plug 'junegunn/fzf.vim'
" }}}1
"  < vim-expand-region > {{{1

Plug 'terryma/vim-expand-region'
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)


" }}}1
 " < minibufexpl > {{{1
" Plug 'techlivezheng/vim-plugin-minibufexpl'
" let g:miniBufExplBRSplit = 0   " Put new window above
" let g:miniBufExplCycleArround = 1
" let g:miniBufExplShowBufNumbers = 1
" let g:miniBufExplBuffersNeeded = 3
" " let g:miniBufExplVSplit = 20   " column width in chars
" noremap - :MBEbn<CR>
" noremap _ :MBEbp<CR>
" nnoremap <Space>t :MBEToggle<cr>
" }}}1
"  < neocomplete.vim > {{{1
if has("lua")
    Plug 'Shougo/neocomplete.vim'
    " Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme' : $HOME.'/.gosh_completions'
                \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    ""  " Recommended key-mappings.
    ""  " <CR>: close popup and save indent.
    ""  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    ""  function! s:my_cr_function()
    ""      return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    ""      " For no inserting <CR> key.
    ""      "return pumvisible() ? "\<C-y>" : "\<CR>"
    ""  endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

    " AutoComplPop like behavior.
    "let g:neocomplete#enable_auto_select = 1

    " Shell like behavior(not recommended).
    "set completeopt+=longest
    "let g:neocomplete#enable_auto_select = 1
    "let g:neocomplete#disable_auto_complete = 1
    "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    " autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" else
    " Plug '~/.vim/bundle/neocomplcache'
    " Plug 'neocomplcache'
    " let g:neocomplcache_enable_at_startup = 1
    " let g:neocomplcache_disable_auto_complete = 1
endif


" }}}1
"  < targets > {{{1
Plug 'wellle/targets.vim'




" }}}1
"  < ctrlp > {{{1

Plug 'kien/ctrlp.vim'
let g:ctrlp_working_path_mode = 's'


" }}}1
"  < vim-auto-save > {{{1

Plug '907th/vim-auto-save'
" let g:auto_save = 0  " enable AutoSave on Vim startup
set updatetime=1000
let g:auto_save=1
let g:auto_save_silent=1
let g:auto_save_events = ["CursorHold"]


" }}}1
"  < vim-move > {{{1

Plug 'matze/vim-move'


" }}}1
Plug 'ervandew/supertab'
" let g:SuperTabNoCompleteBefore = [];
let g:SuperTabNoCompleteAfter = ['^','\s']

let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-p>"
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextDiscoverDiscovery = ["&completefunc:<c-p>", "&omnifunc:<c-x><c-o>"]
" Problem with load order (vimrc is evaluated before latex-box setting of omnifunc)
" \ verbose set omnifunc? | " is empty
" added this autocommand to after/ftplugin/tex.vim
" :do FileType solves also the problem
" autocmd FileType *
" \ if &omnifunc != '' |
" \ call SuperTabChain(&omnifunc, "<c-p>") |
" \ call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
" \ endif


" }}}1
"  < auto-pairs > {{{1
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsMapSpace = 0
" }}}1
"  < vim-autoread > {{{1
Plug 'djoshea/vim-autoread'
" }}}1
"  < vim-sneak > {{{1
Plug 'justinmk/vim-sneak'
"replace 'f' with 1-char Sneak
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F
"replace 't' with 1-char Sneak
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T

" nmap ' <Plug>SneakNext

let g:sneak#streak = 1
let g:sneak#use_ic_scs = 1
"  " not very useful
"  " Plug 'justinmk/vim-dirvish'
" color
" hi link SneakPluginTarget Type
" hi link SneakPluginScope Function
" hi link SneakStreakTarget Type
hi link SneakStreakMask Text
hi SneakPluginTarget guifg=black guibg=yellow ctermfg=black ctermbg=yellow
hi SneakStreakTarget guifg=black guibg=blue ctermfg=black ctermbg=blue
" hi SneakStreakMask guifg=white guibg=black ctermfg=white ctermbg=black
" hi SneakPluginScope  guifg=black guibg=yellow ctermfg=black ctermbg=yellow

" }}}1
"  < vim-easymotion > {{{1

" Plug 'easymotion/vim-easymotion'
" " map <Space> <Plug>(easymotion-prefix)
" map <Space> <Plug>(easymotion-prefix)
" " map f <Plug>(easymotion-prefix)
" "    <Plug> Mapping Table | Default
" "    ---------------------|----------------------------------------------
" "    <Plug>(easymotion-f) | <Leader>f{char}
" "    <Plug>(easymotion-F) | <Leader>F{char}
" "    <Plug>(easymotion-t) | <Leader>t{char}
" "    <Plug>(easymotion-T) | <Leader>T{char}
" "    <Plug>(easymotion-w) | <Leader>w
" "    <Plug>(easymotion-W) | <Leader>W
" "    <Plug>(easymotion-b) | <Leader>b
" "    <Plug>(easymotion-B) | <Leader>B
" "    <Plug>(easymotion-e) | <Leader>e
" "    <Plug>(easymotion-E) | <Leader>E
" "    <Plug>(easymotion-ge)| <Leader>ge
" "    <Plug>(easymotion-gE)| <Leader>gE
" "    <Plug>(easymotion-j) | <Leader>j
" "    <Plug>(easymotion-k) | <Leader>k
" "    <Plug>(easymotion-n) | <Leader>n
" "    <Plug>(easymotion-N) | <Leader>N
" "    <Plug>(easymotion-s) | <Leader>s
" 
" " <Leader>f{char} to move to {char}
" " map  <Leader>f <Plug>(easymotion-bd-f)
" " nmap <Leader>f <Plug>(easymotion-overwin-f)
" " map  f <Plug>(easymotion-bd-f)
" " nmap F <Plug>(easymotion-overwin-f)
" 
" " s{char}{char} to move to {char}{char}
" " nmap <Leader>s <Plug>(easymotion-overwin-f2)
" " Require tpope/vim-repeat to enable dot repeat support
" " Jump to anywhere with only `s{char}{target}`
" " `s<CR>` repeat last find motion.
" " nmap s <Plug>(easymotion-s)
" " Bidirectional & within line 't' motion
" " map <Space><Space>  <Plug>(easymotion-bd-jk)
" map <Space>h        <Plug>(easymotion-linebackward)
" map <Space>l        <Plug>(easymotion-lineforward)
" 
" " Gif config
" " map  / <Plug>(easymotion-sn)
" " omap / <Plug>(easymotion-tn)
" 
" " These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" " Without these mappings, `n` & `N` works fine. (These mappings just provide
" " different highlight method and have some other features )
" " map  n <Plug>(easymotion-next)
" " map  N <Plug>(easymotion-prev)
" 
" let g:EasyMotion_smartcase = 1
" let g:EasyMotion_enter_jump_first = 1
" 
" 
" " }}}1
"  < Tagbar > {{{1

Plug 'majutsushi/tagbar'
nnoremap tb :TlistClose<cr>:TagbarToggle<cr>

let g:tagbar_width=30
" let g:tagbar_left=1
" }}}1
"  < snipmate.vim > {{{1
Plug 'ervandew/snipmate.vim'
" }}}1
"  < python-mode > {{{1
Plug 'python-mode/python-mode'
let g:pymode_doc = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_syntax_space_errors = 0
" close pymode fold cause it is too slow
let g:pymode_folding = 0
" let g:pymode_syntax_indet_errors = 0
let g:pymode_trim_whitespaces = 0
" }}}1
"  < vim-repeat > {{{1
Plug 'tpope/vim-repeat'
" }}}1
"  < visualrepeat > {{{1
Plug 'vim-scripts/visualrepeat'
" }}}1
"  < nerdcommenter > {{{1

Plug 'scrooloose/nerdcommenter'
let NERDSpaceDelims = 1

Plug 'scrooloose/nerdtree'


" }}}1
" < repmo.vim > {{{1
" Plug 'vim-scripts/repmo.vim'
" }}}1
"  < Syntastic > {{{1

Plug 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()} "show error in ubuntu
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 1
let g:syntastic_auto_loc_list = 1       "default is 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

if has("lua")
    let g:syntastic_cpp_compiler = 'g++'
else
    let g:syntastic_cpp_compiler = 'g++5.3'
endif

let g:syntastic_cpp_compiler_options = ' -std=c++11 '

" no pylint for syntax check
let g:syntastic_mode_map = {
            \ "mode": "active",
            \ "active_filetypes": [] }
" , \ "passive_filetypes": ["python"] }
" no +python compile for vim, so can not use pymode also
" let g:pymode_lint_on_write = 0

let g:syntastic_enable_rust_checker = 1
let g:syntastic_rust_checkers = ['rustc']

let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl', 'perlcritic', 'podchecker']
let g:kevincwd = getcwd()
if g:kevincwd == "/home/kevin/trunk"
    let g:syntastic_perl_lib_path = ['/home/kevin/trunk/ExternalModels', '/home/kevin/trunk/Source']
elseif g:kevincwd == "/home/kevin/VLCT-Conversion/VLCT-Conversion"
    let g:syntastic_perl_lib_path = ['/home/kevin/VLCT-Conversion/VLCT-Conversion/lib']
elseif g:kevincwd == "/home/kevin/tarballs/trunk"
    let g:syntastic_perl_lib_path = ['/home/kevin/tarballs/trunk/ExternalModels', '/home/kevin/tarballs/trunk/Source']
elseif g:kevincwd == "/home/kevin/svn/pattern_conversion_scripts/Vlct_Conversion_Tool/trunk"
    let g:syntastic_perl_lib_path = ['/home/kevin/svn/pattern_conversion_scripts/Vlct_Conversion_Tool/trunk/ExternalModels', '/home/kevin/svn/pattern_conversion_scripts/Vlct_Conversion_Tool/trunk/Source']
elseif g:kevincwd == "/home/kevin/0816/checkpin"
    let g:syntastic_perl_lib_path = ['/home/kevin/0816/checkpin/ExternalModels', '/home/kevin/0816/checkpin/Source']
endif

" let g:syntastic_enable_java_checker = 1
" let g:syntastic_java_checker = 'javac'
" let g:syntastic_java_javac_classpath = 'javac'
" use eclim for java syntax check
" let g:EclimJavaValidate = 1
" }}}1
"  < vim-sdcv > {{{1
Plug 'chusiang/vim-sdcv'
nmap <space>w :call SearchWord()<CR>
set keywordprg='sdcv'
" }}}1
"  < vim-surround > {{{1
Plug 'tpope/vim-surround'
" }}}1
 " < vim-airline > {{{1
Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts=1
let g:airline_theme='tomorrow'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_idx_mode = 1
" let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'long', 'mixed-indent-file' ]
let g:airline#extensions#whitespace#checks = [ 'indent' ]
nmap <Space>1 <Plug>AirlineSelectTab1
nmap <Space>2 <Plug>AirlineSelectTab2
nmap <Space>3 <Plug>AirlineSelectTab3
nmap <Space>4 <Plug>AirlineSelectTab4
nmap <Space>5 <Plug>AirlineSelectTab5
nmap <Space>6 <Plug>AirlineSelectTab6
nmap <Space>7 <Plug>AirlineSelectTab7
nmap <Space>8 <Plug>AirlineSelectTab8
nmap <Space>9 <Plug>AirlineSelectTab9
nmap _ <Plug>AirlineSelectPrevTab
nmap - <Plug>AirlineSelectNextTab
" nmap - <Plug>AirlineSelectPrevTab
" nmap + <Plug>AirlineSelectNextTab
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#buffer_min_count = 2
" let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#keymap_ignored_filetypes = ['vimfiler', 'nerdtree', 'quickfix', 'rst']
let g:airline#extensions#tabline#excludes = ['__doc__']
Plug 'vim-airline/vim-airline-themes'
" install fonts
" clone
" git clone https://github.com/powerline/fonts.git --depth=1
" install
" cd fonts
" ./install.sh
" }}}1
"  < Mark--Karkat > {{{1
Plug 'vim-scripts/Mark--Karkat'
" }}}1
"  < vim-pyer > {{{1
Plug '~/codes/vim/vim-pyer'
" }}}1
"             << ------------ Plug End >> {{{1
call plug#end()            " required

" }}}1

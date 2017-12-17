unmap <Leader>r
unmap <Leader>rwp
if findfile("Makefile") == "Makefile"
    map <Leader>r :update<CR>:!./out<CR>
else
    map <Leader>r :update<CR>:!./%<CR>
endif



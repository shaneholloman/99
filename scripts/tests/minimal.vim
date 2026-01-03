set noswapfile
set rtp+=.

let s:paths = [
    \ "../plenary.nvim",
    \ expand("~/.local/share/nvim/lazy/plenary.nvim"),
    \ expand("~/.local/share/nvim/site/pack/*/start/plenary.nvim"),
    \ expand("~/.config/nvim/pack/*/start/plenary.nvim"),
    \ expand("~/.config/nvim/plugged/plenary.nvim"),
    \ ]

for s:path in s:paths
    if isdirectory(s:path)
        execute "set rtp+=" . s:path
        break
    endif
endfor

runtime! plugin/plenary.vim


syntax on
colorscheme torte
set hlsearch
set backspace=indent,eol,start

set nowrap
set ts=4
set softtabstop=4
set shiftwidth=4
set expandtab
" set ai

" set laststatus=2
set number
" set incsearch

set smartindent
set confirm
" set paste
set splitright

" my key mappings
"   F2: search current word without moving cursor
"   F3: copy current word
"   F4: replace the yanked word to current word, and keep the buffer
"       unchanged.
"   F5: delete current word
" nnoremap <F2> :let @/ = "\\<<C-R><C-W>\\>"<CR>
nnoremap <F2> :let @/ = expand('<cword>')<CR>:set hls<CR>
" nnoremap <F2> *# 
nnoremap <F3> yiw
nnoremap <F4> viwpyiw
nnoremap <F5> viwd

set tabline=%!MyTabLine()
hi TabLineSel cterm=bold,reverse

function MyTabLine()

    let s = '' " complete tabline goes here

    " loop through each tab page
    for t in range(tabpagenr('$'))
        " set highlight for tab number and &modified
        let s .= '%#TabLineSel#'
        " set the tab page number (for mouse clicks)
        let s .= '%' . (t + 1) . 'T'
        " set page number string
        let s_old = s
        let s .= '[' . (t + 1) . ']'
        " get buffer names and statuses
        let n = ''  "temp string for buffer names while we loop and check buftype
        let m = 0  " &modified counter
        let bc = len(tabpagebuflist(t + 1))  "counter to avoid last ' '

        " loop through each buffer in a tab
        for b in tabpagebuflist(t + 1)
            " buffer types: quickfix gets a [Q], help gets [H]{base fname}
            " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
            if getbufvar( b, "&buftype" ) == 'help'
                let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
            elseif getbufvar( b, "&buftype" ) == 'quickfix'
                let n .= '[Q]'
            else
                let n .= pathshorten(bufname(b))
            endif

            " check and ++ tab's &modified count
            if getbufvar( b, "&modified" )
                let m += 1
            endif

            " no final ' ' added...formatting looks better done later
            if bc > 1
                let n .= ' '
            endif
            let bc -= 1
        endfor

        " add modified label [n+] where n pages in tab are modified
        if m > 0
            let s = s_old . '[' . (t + 1) . '+]'
        endif
    
        " select the highlighting for the buffer names
        " my default highlighting only underlines the active tab
        " buffer names.
        if t + 1 == tabpagenr()
            let s .= '%#TabLine#'
        else
            let s .= '%#TabLineSel#'
        endif

        " add buffer names
        let s .= n
        " switch to no underlining and add final space to buffer list
        let s .= '%#TabLineSel#' . ' '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'
    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLineFill#%999Xclose'
    endif
    return s
endfunction


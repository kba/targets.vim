" targets.vim Provides additional text objects
" Author:  Christian Wellenbrock <christian.wellenbrock@gmail.com>
" License: MIT license
" Updated: 2014-02-22
" Version: 0.0.3

set runtimepath+=../
set softtabstop=16 expandtab
source ../plugin/targets.vim

function! s:execute(operation, motions)
    if a:operation == 'c'
        execute "normal " . a:operation . a:motions . "_"
    elseif a:operation == 'v'
        execute "normal " . a:operation . a:motions
        normal r_
    else
        execute "normal " . a:operation . a:motions
    endif
    if a:operation == 'y'
        execute "normal A\<Tab>'\<C-R>\"'"
    endif
    execute "normal I" . a:operation . a:motions . "\<Tab>\<Esc>"
endfunction

function! s:testBasic()
    edit test1.in
    normal gg0

    for delset in [
                \ [ '(', ')', 'b' ],
                \ [ '{', '}', 'B' ],
                \ [ '[', ']', 'r' ],
                \ [ '<', '>', 'a' ]
                \ ]
        normal "lyy

        for op in [ 'c', 'd', 'y', 'v' ]
            for cnt in [ '', '1', '2' ]
                for nl in [ '', 'n', 'l' ]
                    for iaIA in [ 'i', 'a', 'I', 'A' ]
                        for del in delset
                            execute "normal \"lpfx"
                            call s:execute(op, cnt . iaIA . nl . del)
                        endfor
                    endfor
                endfor
            endfor
        endfor

        normal +
    endfor

    normal +

    for del in [ "'", '"', '`' ]
        normal "lyy

        for op in [ 'c', 'd', 'y', 'v' ]
            for cnt in [ '', '1', '2' ]
                for nlNL in [ '', 'n', 'l', 'N', 'L' ]
                    for iaI in [ 'i', 'a', 'I' ]
                        execute "normal \"lpfx"
                        call s:execute(op, cnt . iaI . nlNL . del)
                    endfor
                endfor
            endfor
        endfor

        normal +
    endfor

    normal +

    for del in [ ',', '.', ';', ':', '+', '-', '~', '_', '*', '/', '|', '\' ]
        normal "lyy

        for op in [ 'c', 'd', 'y', 'v' ]
            for cnt in [ '', '1', '2' ]
                for nlNL in [ '', 'n', 'l', 'N', 'L' ]
                    for iaIA in [ 'i', 'a', 'I', 'A' ]
                        execute "normal \"lpfx"
                        call s:execute(op, cnt . iaIA . nlNL . del)
                    endfor
                endfor
            endfor
        endfor

        normal +
    endfor

    write! test1.out
endfunction

function! s:testMultiline()
    edit! test2.in
    normal gg0

    " TODO: this test fails for `cI{`
    execute "normal /comment 1\<CR>"
    execute "normal cin{foo\<Esc>"

    execute "normal /comment 2\<CR>"
    execute "normal cin;foo\<Esc>"

    execute "normal /comment 3\<CR>"
    execute "normal cin`foo\<Esc>"

    write! test2.out
endfunction

call s:testBasic()
call s:testMultiline()

quit!

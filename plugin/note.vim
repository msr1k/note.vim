"=============================================================================
"    Description: Tiny plugin to take a note
"         Author: msr1k <msr0210@gmail.com>
"                 https://github.com/msr1k
"=============================================================================
scriptencoding utf-8

if exists('g:loaded_note_vim')
  finish
endif
let g:loaded_note_vim = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:basename = '.note'
let s:ext = '.md'
let s:name = ''

function! s:GetFileName() abort
  if s:name ==? ''
    return s:basename . s:ext
  else
    return s:basename . '.' . s:name . s:ext
  end
endfunction

function! s:EchoFileName() abort
  echo '[Note.vim] Current note: ' . s:GetFileName()
endfunction

function! s:SpecifyNoteName(...) abort
  if a:0 >= 1
    if a:1 =~? '^\w\+$'
      let s:name = a:1
    else
      echoerr '[Note.vim] ERROR: invalid name specified. (name should match "^\w\+$")'
    end
  else
    let s:name = ''
  end
endfunction

function! s:CompName(lead, line, pos) abort
  echomsg a:line

  let filelist = glob('.*', 0, 1)
  let l = []
  for f in filelist
    let match_result = matchlist(f, '\.note\.\(\w\+\)\' . s:ext)
    if len(match_result) != 0
      call add(l, match_result[1])
    endif
  endfor

  let m = matchlist(a:line, '\s\+\(\w\+\)\?$')
  if len(m) != 0
    let c = []
    for i in l
      if i =~# '^' . m[1]
        call add(c, i)
      endif
    endfor
    return c
  else
    return l
  endif
endfunction

function! s:Opener(cmd) abort
  let s:win_id = win_getid()
  let s:target_file = expand('%')
  let num = bufwinnr(s:GetFileName())
  if num != -1
    silent execute num . 'wincmd w'
  else
    let cmd = a:cmd . ' ' . s:GetFileName()
    silent execute cmd
  endif
endfunction

function! s:Open()
  call s:Opener(':e')
endfunction

function! s:Split()
  call s:Opener(':split')
endfunction

function! s:Vsplit()
  call s:Opener(':vsplit')
endfunction

function! s:Back() abort
  if win_getid() == s:win_id
    silent execute ':e ' . s:target_file
  else
    let target = 0
    let total = winnr('$')
    for n in range(1, total)
      if win_getid(n) == s:win_id
        let target = n
      endif
    endfor
    if target != 0
      :exe target.'wincmd w'
    else
      silent execute ':e ' . s:target_file
    endif
  endif
endfunction

command! -nargs=? -complete=customlist,s:CompName CNote  :call s:SpecifyNoteName(<f-args>)      " Choose note name to use
command! FNote :call s:EchoFileName()  " Filename of current note
command! Note  :call s:Open()
command! SNote :call s:Split()
command! VNote :call s:Vsplit()
command! Eton  :call s:Back()

let &cpoptions = s:save_cpo
unlet s:save_cpo



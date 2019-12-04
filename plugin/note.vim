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
  if s:name == ''
    return s:basename . s:ext
  else
    return s:basename . '.' . s:name . s:ext
  end
endfunction

function! s:SpecifyNoteName(name)
  let s:name = a:name
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

command! -nargs=1 CNote  :call s:SpecifyNoteName(<f-args>)      " Choose note name to use
command! Note  :call s:Open()
command! SNote :call s:Split()
command! VNote :call s:Vsplit()
command! Eton  :call s:Back()

let &cpoptions = s:save_cpo
unlet s:save_cpo



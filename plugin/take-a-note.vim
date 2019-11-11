"=============================================================================
"    Description: Tiny plugin to take a note
"         Author: msr1k <msr0210@gmail.com>
"                 https://github.com/msr1k
"=============================================================================
scriptencoding utf-8

if exists('g:loaded_take_a_note')
  finish
endif
let g:loaded_take_a_note = 1

let s:save_cpo = &cpo
set cpo&vim

let s:filename = ".note.md"

function! s:Opener(cmd, first, last)
  let s:target_file = expand('%')
  let s:target_range = [ a:first, a:last ]
  let noteWindowNumber = bufwinnr(s:filename)
  if noteWindowNumber != -1
    silent execute noteWindowNumber . 'wincmd w'
  else
    let cmd = a:cmd . ' ' . s:filename
    silent execute cmd
  endif
endfunction

function! s:Open() range
  call s:Opener(':e', a:firstline, a:lastline)
endfunction

function! s:Split() range
  call s:Opener(':split', a:firstline, a:lastline)
endfunction

function! s:Back()
  silent execute ":e " . s:target_file
endfunction

command! -range NoteFileOpen :<line1>,<line2>call s:Open()
command! -range NoteFileSplit :<line1>,<line2>call s:Split()
command! NoteFileBack :call s:Back()

let &cpo = s:save_cpo
unlet s:save_cpo



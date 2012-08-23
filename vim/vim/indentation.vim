" File: indentation.vim
" Project: scyn-conf/vim
" Brief: Vim indentation configuration file
" Author: Scyn - Remi Chaintron <remi.chaintron@gmail.com>
"

" Options:{{{
"------------------------------------------------------------------------------
" Do NOT insert spaces instead of tabs
" set noexpandtab
" Number of spaces in the file a <Tab> counts for.
" (/!\ This value should not be changed!)
set tabstop=8
" Number of columns a <Tab> counts for
set softtabstop=4
" Number of spaces to use for each step of indentation
set shiftwidth=4
" Insert blanks according to shiftwidth, tabstop and softtabstop
set smarttab
" Set auto indentation
set autoindent


" }}}
" Functions:{{{
"------------------------------------------------------------------------------
" Display tabs
function! s:SeeTabs()
	if !exists("g:SeeTabEnabled")
		let g:SeeTabEnabled = 1
		let g:SeeTab_list = &list
		let g:SeeTab_listchars = &listchars
		let regA = @a
		redir @a
		silent! hi SpecialKey
		redir END
		let g:SeeTabSpecialKey = @a
		let @a = regA
		silent! hi SpecialKey guifg=#555555 guibg=NONE gui=NONE ctermfg=darkgray ctermbg=NONE        cterm=NONE
		set list
		set listchars=tab:\|\ 
	else
		let &list = g:SeeTab_list
		let &listchars = &listchars
		silent! exe "hi ".substitute(g:SeeTabSpecialKey,'xxx','','e')
		unlet g:SeeTabEnabled g:SeeTab_list g:SeeTab_listchars
	endif
endfunction


" Reindent current file
function! s:ReindentFile()
  silent! execute "normal ggvG=``"
endfunction


"}}}"
" Commands: {{{
"------------------------------------------------------------------------------
command! -nargs=0	ReindentFile	call s:ReindentFile()
command! -nargs=0	SeeTabs		call s:SeeTabs()


"}}}
" Mappings:{{{
"------------------------------------------------------------------------------
" Reindent current file
noremap <silent>	<F12>	:ReindentFile<CR>
noremap <silent>	==	:ReindentFile<CR>
" SeeTabs mapping
noremap <silent>	<F11>	:SeeTabs<CR>
" IndentStyle mapping
noremap <silent>	<F10>	:IndentStyle<CR>


"}}}



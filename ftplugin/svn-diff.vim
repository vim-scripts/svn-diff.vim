" made by Michael Scherer ( misc@mandrake.org )
" $Id: svn.vim 140 2004-05-05 15:12:09Z misc $
" TODO - do not ask if the new buffer should be wrote
"        on quit
"
" to use it, place it in ~/.vim and add 
"    au BufRead svn-commit.tmp source ~/.vim/svn.vim
" to your .vimrc


function! Svn_diff_windows()
python <<EOF
import vim
import re
svn_re=re.compile('^--This line, and those below, will be ignored--$')
modif_re=re.compile('^MM?:\s*(.*)\s*$')
win=vim.windows[0]
svn_found=0
list_of_files=''

for b in win.buffer:
	if svn_re.search(b):
		svn_found=1
	if not svn_found:
		break
		
	if modif_re.search(b):
		list_of_files=list_of_files+' '+modif_re.match(b).group(1)

		
vim.command("new")
win.height=len(win.buffer)+2
# use normal to remove annoying 'hit enter messages'
vim.command("normal :r!svn diff " + list_of_files + "\n")
vim.command("set ft=diff")
vim.command("wincmd R")

EOF
endfunction
set nowarn

call Svn_diff_windows()
set nowb

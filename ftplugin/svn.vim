" made by Michael Scherer ( misc@mandrake.org )
" $Id: svn.vim 282 2005-01-31 21:24:55Z misc $
" TODO - rewrite in pure vim functions
"
" 2004-09-13 : Lukas Ruf ( lukas.ruf@lpr.ch )
"   - re-ordered windows
"   - set focus on svn-commit.tmp (that's where one has to write)
"   - set buffer type of new window to 'nofile' to fix 'TODO'
"
" 2005-01-31 : 
"   - autoclose on exit, thanks to Gintautas Miliauskas ( gintas@akl.lt )
"     and tips from Marius Gedminas ( mgedmin@b4net.lt )
"
" to use it, place it in ~/.vim and add 
"    au BufRead svn-commit.tmp source ~/.vim/svn.vim
" to your .vimrc


function! Svn_diff_windows()
python <<EOF
import vim
import re
svn_re=re.compile('^--This line, and those below, will be ignored--$')
modif_re=re.compile('^MM?\s*(.*)\s*$')
win=vim.windows[0]
svn_found=0
list_of_files=''

for b in win.buffer:
	if svn_re.search(b):
		svn_found=1
	if not svn_found:
		continue
		
	if modif_re.search(b):
		list_of_files=list_of_files+' '+modif_re.match(b).group(1)

vim.command("new")
win.height=len(win.buffer)+2
# use normal to remove annoying 'hit enter messages'
vim.command("normal :r!svn diff " + list_of_files + "\n")
vim.command("set previewwindow ft=diff")
vim.command("set buftype=nofile")
vim.command("wincmd p")
vim.command("wincmd R")
vim.command('goto 1')

EOF
endfunction
set nowarn

call Svn_diff_windows()
set nowb

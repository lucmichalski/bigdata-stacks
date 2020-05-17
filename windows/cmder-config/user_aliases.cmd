;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
clear=cls
history=cat "%CMDER_ROOT%\config\.history"
unalias=alias /d $1
vi=vim $*
cmderr=cd /d "%CMDER_ROOT%"


e.=explorer .
..=cd ..
~=cd /d "%UserProfile%
cd=cd $1 & ls
pwd=cd
cl=clear
ls=ls --show-control-chars -F --color $*
gl=git log --oneline --all --graph --decorate  $*
glb=git-log --branches --date-order
gst=git status
gch=git checkout
gaa=git add --all
grv=git remote -v
gc=git commit
gp=git push
gl=git pull
glum=git pull upstream master

nv=nvim.exe
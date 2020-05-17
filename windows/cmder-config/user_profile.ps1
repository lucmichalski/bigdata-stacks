# Use this file to run your own startup commands
## Prompt Customization
<#
.SYNTAX
    <PrePrompt><CMDER DEFAULT>
    λ <PostPrompt> <repl input>
.EXAMPLE
    <PrePrompt>N:\Documents\src\cmder [master]
    λ <PostPrompt> |
#>

[ScriptBlock]$PrePrompt = {
}

# Replace the cmder prompt entirely with this.
# [ScriptBlock]$CmderPrompt = { }

[ScriptBlock]$PostPrompt = {

}

## <Continue to add your own>

# alias settings
#@ system {{{
function getFileName {Get-ChildItem -Name}

## define
Remove-Item alias:\ls

Set-Alias ls getFileName
Set-Alias ll Get-ChildItem

#Set-Alias md="mkdir -p"
#Set-Alias cp="cp -rf"
#Set-Alias rm="rm -rf"
#Set-Alias grep="grep --color=auto"
#}}}

#@ apps {{{
function Zrc  {nvim $PROFILE}
function Vrc  {nvim C:\User\Administrator\vimfiles\vimrc}
function Gcl  {git clone}
function Gclp {git clone git@github.com:}
function Grv  {git remote -v}
function Gra  {git remote add}
function Gb   {git branch}
function Gbd  {git branch -D}
function Gch  {git checkout}
function Gst  {git status}
function Gaa  {git add --all}
function Gcm  {git commit -m}
function Gp   {git push}
function Gl   {git pull}
function Glum {git pull upstream master}
function Gmg  {git merge}
function Gcp  {git cherry-pick}
#function Shdfs {start-dfs.sh && start-yarn.sh && start-master.sh && start-slaves.sh}
#function Stophdfs {stop-all.sh && stop-master.sh && stop-slaves.sh}

## define
# Remove-Item alias:\nv
# Remove-Item alias:\gcm
# Remove-Item alias:\gl
# Remove-Item alias:\gp

Set-Alias zrc Zrc
Set-Alias vrc Vrc
Set-Alias ne  nvim

set-Alias  gcl      Gclp
set-Alias  gclp     Gclp
set-Alias  grv      Grv
set-Alias  gra      Gra
set-Alias  gb       Gb
set-Alias  gbd      Gbd
set-Alias  gch      Gch
set-Alias  gst      Gst
set-Alias  gaa      Gaa
set-Alias  ggcm     Gcm
set-Alias  ggp      Gp
set-Alias  ggl      Gl
set-Alias  glum     Glum
set-Alias  gmg      Gmg
set-Alias  gcp      Gcp
#set-Alias  shdfs    Shdfs
#set-Alias  stophdfs Stophdfs
#}}}
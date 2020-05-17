
# install
Set-ExecutionPolicy RemoteSigned -scope CurrentUser

[environment]::setEnvironmentVariable('SCOOP', 'D:\devtools\Scoop', 'Machine')
$env:SCOOP='D:\devtools\Scoop'
iex (new-object net.webclient).downloadstring('https://get.scoop.sh')

[environment]::setEnvironmentVariable('SCOOP_GLOBAL','D:\devtools\Scoop\GlobalScoopApps','Machine')
$env:SCOOP_GLOBAL='D:\devtools\Scoop\GlobalScoopApps'

# oh-my-posh
Install-Module posh-git -Scope AllUsers
Install-Module oh-my-posh -Scope AllUsers
Import-Module oh-my-posh

Set-Theme PowerLine

scoop install -g shellcheck
scoop install -g ripgrep

# sshkey
# ssh-keygen -t rsa -C "395577197.com"
# ================================================================================
#  File Name    : vim-install/windows/my-config-install.ps1
#  Author       : AlanDing
#  mail         :
#  Created Time : Thu 18 Apr 2019 10:48:29 PM CST
# ================================================================================


git clone git@github.com:alanding1989/SpaceVim.git %HOME%\.SpaceVim
git clone git@github.com:alanding1989/my-Vim.git %HOME%\.SpaceVim.d

mklink /D %HOME%\AppData\Local\nvim %HOME%\.SpaceVim
mklink /D %HOME%\vimfiles %HOME%\.SpaceVim.d

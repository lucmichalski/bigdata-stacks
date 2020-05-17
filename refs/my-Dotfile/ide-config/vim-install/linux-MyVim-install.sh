#!/usr/bin/env bash

# ================================================================================
#  File Name    : vim-install/linux/my-config-install.sh
#  Author       : AlanDing
#  Created Time : Thu 18 Apr 2019 10:40:27 PM CST
# ================================================================================

whoami=$(whoami)

# {{{
function isRoot() {
    if [[ $whoami == "root" ]]; then
        logout
    fi

    if [[ $whoami == "root" ]]; then
        echo "please install with Non-Root user" && exit 1
    fi
}


function installForNonRoot() {
    if [[ ! -e "$HOME/.SpaceVim" ]]; then
        git clone git@github.com:alanding1989/SpaceVim.git   "$HOME/.SpaceVim"
        git clone git@github.com:alanding1989/my-Vim.git     "$HOME/.SpaceVim.d"
        rm -rf $HOME/.config/nvim && ln -s $HOME/.SpaceVim    $HOME/.config/nvim
    fi

    if [[ ! -e "$HOME/.vim" ]]; then
        ln -s $HOME/.SpaceVim.d  $HOME/.vim
    fi
}


function installForRoot() {
    if [[ ! -e "/root/.SpaceVim" ]]; then
        sudo ln -s $HOME/.SpaceVim    /root/.SpaceVim
        sudo ln -s $HOME/.SpaceVim.d  /root/.SpaceVim.d
        sudo ln -s $HOME/.SpaceVim.d  /root/.vim
        sudo ln -s /root/.SpaceVim    /root/.config/nvim
    fi
}

function main() {
    isRoot
    installForNonRoot
    installForRoot
}
# }}}

main


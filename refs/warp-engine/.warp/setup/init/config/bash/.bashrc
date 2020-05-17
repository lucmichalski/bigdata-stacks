# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
#eval "`/usr/bin/dircolors`"

alias ls='ls $LS_OPTIONS'
alias ll='ls -lh $LS_OPTIONS'
alias l='ls -lhA $LS_OPTIONS'

#export GREP_OPTIONS='--color=auto'

#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "


export NVM_DIR="/root/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Magento shortcut
alias mage2clean="rm -rf generated/code/ var/cache/ var/page_cache/ var/session/ var/view_preprocessed/ var/composer_home/ pub/static/_cache pub/static/adminhtml/ pub/static/frontend/ && bin/magento cache:clean"
alias mage2flush="rm -rf generated/code/ var/cache/ var/page_cache/ var/session/ var/view_preprocessed/ var/composer_home/ pub/static/_cache pub/static/adminhtml/ pub/static/frontend/ && bin/magento cache:flush"
alias mage2generated="rm -rf generated/code/ var/cache/"
alias mage2smile="bin/magento config:set -l smile_elasticsuite_core_base_settings/es_client/servers elasticsearch:9200 && \
    bin/magento config:set -l smile_elasticsuite_core_base_settings/es_client/enable_https_mode 0 && \
    bin/magento config:set -l smile_elasticsuite_core_base_settings/es_client/enable_http_auth 0 && \
    bin/magento config:set -l smile_elasticsuite_core_base_settings/es_client/http_auth_user \"\" && \
    bin/magento config:set -l smile_elasticsuite_core_base_settings/es_client/http_auth_pwd \"\" && \
    bin/magento app:config:import"

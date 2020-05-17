#!/bin/bash

function magento_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp magento [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " -T                 $(warp_message 'disable pseudo TTY. Useful for Jenkins integration')"
    warp_message_info   " --root             $(warp_message 'execute bin/magento with root privileges')"
    warp_message_info   " --download         $(warp_message 'Download Magento Community')"
    warp_message_info   " --install          $(warp_message 'Install Magento with setup previously configured in wizard')"
    warp_message_info   " --install-only     $(warp_message 'Install Magento only with configured parameters')"
    warp_message_info   " --config-varnish   $(warp_message 'Configure Varnish')"
    warp_message_info   " --config-redis     $(warp_message 'Configure Redis')"
    warp_message_info   " --config-smile     $(warp_message 'Configure Smile if installed')"
    warp_message_info   " --config-dev       $(warp_message 'Configure Magento optimized in developer mode')"
    warp_message_info   " --generate-data    $(warp_message 'Generate sample data with Magento performance Toolkit')"

    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Allow run bin/magento inside the container "
    warp_message " It also brings --options to configure services in Magento,"
    warp_message " like redis, varnish or optimize development in developer mode"
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp magento cache:clean"
    warp_message " warp magento --download 2.3.1"
    warp_message " warp magento --install"
    warp_message ""    
}

function magento_help()
{
    warp_message_info   " magento            $(warp_message 'execute bin/magento inside the container')"
}

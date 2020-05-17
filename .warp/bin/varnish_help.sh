#!/bin/bash

function varnish_help_usage()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp varnish [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " varnish service used inside the container: $(warp_message_bold '.port 80 .host web') "
    warp_message " to use this service you must generate your own configuration file, please run $(warp_message_bold 'warp magento --config-varnish') "
    warp_message ""

}

function varnish_help()
{
    warp_message_info   " varnish            $(warp_message 'service of varnish')"
}

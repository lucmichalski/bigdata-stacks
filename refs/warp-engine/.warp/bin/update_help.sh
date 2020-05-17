#!/bin/bash

function update_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp update [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " -f, --force        $(warp_message 'force update without confirmation')"
    warp_message_info   " --images           $(warp_message 'update images from hub registry docker')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " To update the framework you must enter the following link and download the latest version"
    warp_message " http://ct.summasolutions.net/warp-engine/"
    warp_message " also can run the following command"
    warp_message " curl -L -o warp http://ct.summasolutions.net/warp-engine/warp && chmod 755 warp && ./warp update"

    # TODO translate to English

    warp_message ""

}

function update_help()
{
    warp_message_info   " update             $(warp_message 'update warp framework')"

}

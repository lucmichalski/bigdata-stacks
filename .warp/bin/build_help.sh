#!/bin/bash

function build_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp build [options] [command]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " You must have an auth.json file that contains your Magento Commerce authorization credentials in your Magento Commerce Cloud root directory."
    warp_message " 1 - Using a text editor, open auth.json.sample file into path to Dockerfile directory."    
    warp_message " 2 - Replace <public-key> and <private-key> with your Magento Commerce authentication credentials.  "    
    warp_message " 3 - Save your changes to auth.json file and exit the text editor."    
    warp_message ""

    warp_message_info "Example:"
    warp_message " warp build --no-cache --tag image:tag path/to/folder/with/Dockerfile"
    warp_message " warp build --no-cache --tag summasolutions/magento:2.3.4-ee images/magento2/2.3.4-ee"
    warp_message ""    
}

function build_help()
{
    warp_message_info   " build              $(warp_message 'build an image from a Dockerfile')"

}

#!/bin/bash

function sync_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp sync command [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"

    warp_message_info   " push               $(warp_message 'copy files from host to container')"
    warp_message_info   " pull               $(warp_message 'copy files from container to host')"
    warp_message_info   " clean              $(warp_message 'stop and clean up all sync endpoints')"

    warp_message ""
    warp_message_info "Help:"
    warp_message " Run your application at full speed while syncing your code for development," 
    warp_message " finally empowering you to utilize docker for development under OSX/"
    warp_message " warp sync push/pull available only is not working with docker-sync"

    warp_message ""

    warp_message_info "Example:"
    warp_message " warp sync clean"
    warp_message " warp sync push --all"
    warp_message " warp sync pull vendor"
    warp_message ""    

}

function pull_help_usage()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp sync command [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " allows to copy files from container to host"

    warp_message ""

    warp_message_info "Example:"
    warp_message " warp sync pull vendor"
    warp_message " warp sync pull file1 file2"
    warp_message " warp sync pull --all"
    warp_message ""    

}

function push_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp sync command [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " allows to copy files from host to container"

    warp_message ""

    warp_message_info "Example:"
    warp_message " warp sync push vendor"
    warp_message " warp sync push file1 file2"
    warp_message " warp sync push --all"    
    warp_message ""    

}

function clean_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp sync [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " Stop and clean up all sync endpoints"

    warp_message ""

    warp_message_info "Example:"
    warp_message " warp sync clean"
    warp_message ""    

}

function sync_help()
{
    warp_message_info   " sync               $(warp_message 'sync files from/to container, only macos')"
}

#!/bin/bash

function rsync_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp rsync command [options] [arguments]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"

    warp_message_info   " push               $(warp_message 'copy files from host to container with rsync')"
    warp_message_info   " pull               $(warp_message 'copy files from container to host with rsync')"

    warp_message ""
    warp_message_info "Help:"
    warp_message " Run your application at full speed while syncing your code for development," 
    warp_message " finally empowering you to utilize docker for development under OSX/"
    warp_message " warp rsync push/pull is necessary only is not working with docker-sync"

    warp_message ""

    warp_message_info "Example:"
    warp_message " warp rsync push --all"
    warp_message " warp rsync pull vendor"
    warp_message ""    

}

function rsync_pull_help_usage()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp rsync pull [options] [arguments]"
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
    warp_message " warp rsync pull vendor"
    warp_message " warp rsync pull file1 file2"
    warp_message " warp rsync pull --all"
    warp_message ""    

}

function rsync_push_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp rsync push [options] [arguments]"
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
    warp_message " warp rsync push vendor"
    warp_message " warp rsync push file1 file2"
    warp_message " warp rsync push --all"    
    warp_message ""    

}

function rsync_help()
{
    warp_message_info   " rsync              $(warp_message 'rsync files from/to container')"
}

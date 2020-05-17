#!/bin/bash

function init_help_usage()
{
    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp init [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message_info   " -n                 $(warp_message 'init without wizard on mode developer')"
    warp_message_info   " --no-interaction   $(warp_message 'init without wizard on mode developer')"
    warp_message ""

    warp_message ""
    warp_message_info "Help:"
    warp_message " this command is used to initialize a wizard with options to create containers"
    warp_message " if you run for the first time, the installation of the framework begins"
    warp_message " After the initial installation, a guided menu with options to create services"
    warp_message " The following services can be configured:"
    warp_message " 1) Web Server with Nginx"
    warp_message " 2) PHP Service"
    warp_message " 3) Database with MySQL"
    warp_message " 4) Service of elasticsearch"
    warp_message " 5) Redis service for cache, session, fpc"
    warp_message ""
    warp_message " If the program detects a previous configuration, it shows a shorter menu of options, to configure:"
    warp_message " 1) Work with one or more projects in parallel"
    warp_message " 2) Configure MySQL ports"
    warp_message ""
    warp_message " Please run ./warp init"
}

function init_help()
{
    warp_message_info   " init               $(warp_message 'run main command to prepare project')"

}

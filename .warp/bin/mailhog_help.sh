#!/bin/bash

function mailhog_help_usage()
{

    warp_message ""
    warp_message_info "Usage:"
    warp_message      " warp mailhog command [options]"
    warp_message ""

    warp_message ""
    warp_message_info "Options:"
    warp_message_info   " -h, --help         $(warp_message 'display this help message')"
    warp_message ""

    warp_message_info "Available commands:"

    warp_message_info   " info               $(warp_message 'display info available')"


    warp_message ""
    warp_message_info "Help:"
    warp_message " MailHog is an email testing tool for developers"
    warp_message " the SMTP server starts on port 1025"
    warp_message " Web interface to view the messages, default http://127.0.0.1:8025"
    warp_message " In PHP you could add this line to php.ini"
    warp_message " sendmail_path = \"/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025\""
    warp_message " for more information about Mailhog you can access the following link: https://github.com/mailhog/MailHog/"

    warp_message ""

    warp_message_info "Example:"
    warp_message " warp mailhog --help"
    warp_message ""    

}

function mailhog_help()
{
    warp_message_info   " mailhog            $(warp_message 'Mailhog SMTP server')"
}

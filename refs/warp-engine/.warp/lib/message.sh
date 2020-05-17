#!/bin/bash

# ANSI color codes
RS="\e[0m"    # reset
HC="\e[1m"    # hicolor
UL="\e[4m"    # underline
INV="\e[7m"   # inverse background and foreground
FBLK="\e[30m" # foreground black
FRED="\e[31m" # foreground red
FGRN="\e[32m" # foreground green
FYEL="\e[33m" # foreground yellow
FBLE="\e[34m" # foreground blue
FMAG="\e[35m" # foreground magenta
FCYN="\e[36m" # foreground cyan
FWHT="\e[97m" # foreground white
FGRY="\e[37m" # foreground gray
BBLK="\e[40m" # background black
BRED="\e[41m" # background red
BGRN="\e[42m" # background green
BYEL="\e[43m" # background yellow
BBLE="\e[44m" # background blue
BMAG="\e[45m" # background magenta
BCYN="\e[46m" # background cyan
BWHT="\e[47m" # background white

function warp_message()
{
    printf "$RS$1\n"
}

function warp_message_error()
{
    warp_message "$FRED$1$RS"
}

function warp_message_ok()
{
    warp_message "$FGRN$1$RS"
}

function warp_message_info()
{
    warp_message "$FCYN$1$RS"
}

function warp_message_info2()
{
    warp_message "$FGRY$1$RS"
}

function warp_message_warn()
{
    warp_message "$FYEL$1$RS"
}

function warp_message_bold()
{
    warp_message "$HC$1$RC"
}



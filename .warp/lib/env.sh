#!/bin/bash


##
# Read a variable from .env file located in root folder
# Use:
#    my_var=$(warp_env_read_var REDIS_CACHE_VERSION)
#    echo $my_var
#
# Globals:
#   PROJECTPATH
# Arguments:
#   $1 Var to read. Ex. REDIS_CACHE_VERSION
# Returns:
#   string
##
function warp_env_read_var()
{
    [ -f $ENVIRONMENTVARIABLESFILE ] && _VAR=$(grep "^$1=" $ENVIRONMENTVARIABLESFILE | cut -d '=' -f2)
    echo $_VAR
}

# Generate RANDOM Password
# Globals:
#   PROJECTPATH
# Arguments:
#   $1 number long password to generate.
# Returns:
#   string
function warp_env_random_password()
{
    set="abcdefghijklmonpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    n=$1
    rand=""
    for i in `seq 1 $n`; do
        char=${set:$RANDOM % ${#set}:1}
        rand+=$char
    done
    echo $rand
}

function warp_env_change_version_sample_file()
{
    WARP_ENV_VERSION=$(grep "^WARP_VERSION" $ENVIRONMENTVARIABLESFILESAMPLE | cut -d '=' -f2)
    _WARP_ENV_VERSION=$(echo $WARP_ENV_VERSION | tr -d ".")

    . $PROJECTPATH/.warp/lib/version.sh
    _WARP_VERSION=$(echo $WARP_VERSION | tr -d ".")

    if [ ! -z "$WARP_ENV_VERSION" ]
    then        
        # SAVE OPTION VERSION
        WARP_VERSION_OLD="WARP_VERSION=$WARP_ENV_VERSION"
        WARP_VERSION_NEW="WARP_VERSION=$WARP_VERSION"

        if [ $_WARP_ENV_VERSION -lt $_WARP_VERSION ] && [ ! $_WARP_ENV_VERSION -eq $_WARP_VERSION ]
        then
            cat $ENVIRONMENTVARIABLESFILESAMPLE | sed -e "s/$WARP_VERSION_OLD/$WARP_VERSION_NEW/" > "$ENVIRONMENTVARIABLESFILESAMPLE.tmp"
            mv "$ENVIRONMENTVARIABLESFILESAMPLE.tmp" $ENVIRONMENTVARIABLESFILESAMPLE
        fi
    fi
}
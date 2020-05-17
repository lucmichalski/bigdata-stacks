#!/bin/bash

##
# Check if the .env file exist
#
# Globals:
#   PROJECTPATH
# Arguments:
#   None
# Returns:
#   0 if exists
#   1 if not exists
##
warp_check_env_file()
{
    if [ -f $ENVIRONMENTVARIABLESFILE ]; then
        return 0 #TRUE
    else
        return 1 #FALSE
    fi;
}


##
# Check if the docker-compose.yml file exist
#
# Globals:
#   PROJECTPATH
# Arguments:
#   None
# Returns:
#   0 if exists
#   1 if not exists
##
warp_check_yaml_file()
{
    if [ -f $DOCKERCOMPOSEFILE ]; then
        return 0 #TRUE
    else
        return 1 #FALSE
    fi;
}

##
# Check if files exist
#
# * docker-compose-warp.yml
# * docker-sync.yml
# * .env
#
# Globals:
#   PROJECTPATH
# Arguments:
#   None
##
function warp_check_files()
{
    INFRA_FILES_ERROR="FALSE"
    INFRA_FILES_ERROR_MAC="FALSE"

    if [ ! -f $DOCKERCOMPOSEFILE ]; then
        INFRA_FILES_ERROR="TRUE"
        echo "* Checking file $(basename $DOCKERCOMPOSEFILE) $(warp_message_error [error])"
    fi; 
    
    if [ ! -f $ENVIRONMENTVARIABLESFILE ]; then
        INFRA_FILES_ERROR="TRUE"
        echo "* Checking file $(basename $ENVIRONMENTVARIABLESFILE) $(warp_message_error [error])"
    fi;

    case "$(uname -s)" in
        Darwin)
        if [ ! -f $DOCKERSYNCMAC ]; then
            INFRA_FILES_ERROR_MAC="TRUE"
            echo "* Checking file $(basename $DOCKERSYNCMAC) $(warp_message_error [error])"
        fi;
        ;;
    esac    

    if [ $INFRA_FILES_ERROR = "TRUE" ]; then
        warp_message ""
        warp_message_warn "-- These files: ($(basename $DOCKERCOMPOSEFILE) and $(basename $ENVIRONMENTVARIABLESFILE)) are necessary to initialize the containers.. $(warp_message_error [error])"
        [ $INFRA_FILES_ERROR_MAC = "TRUE" ] && warp_message_warn "-- This files: $(basename $DOCKERSYNCMAC) is necessary in macOS.. $(warp_message_error [error])"
        warp_message_warn "-- To initialize the project please Run: $(warp_message_bold './warp init')"
        exit
    fi
}

# WARNING MESSAGE IF TO USE MAC 
# MacOS not soport multi-projects
warp_check_os_mac() {
    case "$(uname -s)" in
        Darwin)
        # autodetect docker in Mac
            warp_message_warn "Warning! Docker for Mac does not support more than one project in parallel"
            warp_message_info "starting simple project.."
            warp_message ""
        ;;
    esac    
}

#######################################
# Check if the docker-components are running
# Globals:
#   DOCKERCOMPOSEFILE
# Arguments:
#   None
# Returns:
#   true|false
#######################################
warp_check_is_running() {
    if [ -f $DOCKERCOMPOSEFILE ]
    then
        #dockerStatusOutput=$(docker-compose -f $DOCKERCOMPOSEFILE ps -q | xargs docker inspect --format='{{ .State.Status }}' | sed 's:^/::g' | grep -i running)
        dockerStatusOutput=$(docker-compose -f $DOCKERCOMPOSEFILE ps --filter status=running --services)
        outputSize=${#dockerStatusOutput}
        if [ "$outputSize" -gt 0 ]; then
            echo true
        else
            echo false
        fi
    else
        echo false
    fi
}

warp_check_php_is_running() {
    if [ -f $DOCKERCOMPOSEFILE ]
    then
        COUNT=0
        while : ; do
            #dockerStatusOutput=$(docker-compose -f $DOCKERCOMPOSEFILE ps -q php | xargs docker inspect --format='{{ .State.Status }}' | sed 's:^/::g' | grep -i running)
            dockerStatusOutput=$(docker-compose -f $DOCKERCOMPOSEFILE ps -q php)
            outputSize=${#dockerStatusOutput}
            if [ "$outputSize" -gt 0 ]; then
                echo true
                break
            else
                sleep 1
                let COUNT=$COUNT+1
                [ $COUNT = 5 ] && echo false && break
            fi
        done        
    else
        echo false
    fi
}

function warp_rsync_is_not_installed() {
    warp_message_warn "rsync is not installed";
    warp_message "Run the following command to Install rsync"
    warp_message "on MacOS \"brew install rsync\"";
    warp_message "on Debian distribution \"apt-get install rsync\"";

    exit 1
}

function warp_check_selenium_is_installed() {

  if [ ! -f $DOCKERCOMPOSEFILESELENIUM ]
  then
    warp_message_warn "selenium has not been installed yet, first run: warp selenium setup";
    exit 1;
  fi;
}

function warp_check_selenium_is_running() {
    if [ -f $DOCKERCOMPOSEFILESELENIUM ]
    then        
        dockerStatusOutput=$(docker-compose -f $DOCKERCOMPOSEFILE -f $DOCKERCOMPOSEFILESELENIUM ps -q seleniumhub)
        outputSize=${#dockerStatusOutput}
        if [ "$outputSize" -gt 0 ] ; then
            echo true
        else
            echo false
        fi
    else
        echo false
    fi
}

warp_check_gitignore()
{
    #  CHECK IF GITIGNOREFILE CONTAINS FILES WARP TO IGNORE
    [ -f $GITIGNOREFILE ] && cat $GITIGNOREFILE | grep --quiet -w "^# WARP FRAMEWORK"

    # Exit status 0 means string was found
    # Exit status 1 means string was not found
    if [ $? = 1 ] || [ ! -f $GITIGNOREFILE ]
    then
        warp_message "* Preparing files for .gitignore $(warp_message_ok [ok])"
        # FILES TO ADD GITIGNORE
        echo ""                  >> $GITIGNOREFILE
        echo "# WARP FRAMEWORK"  >> $GITIGNOREFILE
        echo "!/warp"            >> $GITIGNOREFILE
        echo "!/$(basename $WARPFOLDER)"                      >> $GITIGNOREFILE
        echo "!/$(basename $WARPFOLDER)/**"                   >> $GITIGNOREFILE
        echo "/$(basename  $ENVIRONMENTVARIABLESFILE)"        >> $GITIGNOREFILE
        echo "/$(basename  $DOCKERCOMPOSEFILE)"               >> $GITIGNOREFILE
        echo "/$(basename  $DOCKERCOMPOSEFILEMAC)"            >> $GITIGNOREFILE
        echo "/$(basename  $DOCKERSYNCMAC)"                   >> $GITIGNOREFILE
        echo "!/$(basename $ENVIRONMENTVARIABLESFILESAMPLE)"  >> $GITIGNOREFILE
        echo "!/$(basename $DOCKERCOMPOSEFILESAMPLE)"         >> $GITIGNOREFILE
        echo "!/$(basename $DOCKERCOMPOSEFILEMACSAMPLE)"      >> $GITIGNOREFILE
        echo "!/$(basename $DOCKERSYNCMACSAMPLE)"             >> $GITIGNOREFILE
        echo "/$(basename  $CHECK_UPDATE_FILE)"               >> $GITIGNOREFILE
        echo "/.docker-sync"                            >> $GITIGNOREFILE        
        echo "/.warp/docker/volumes"                    >> $GITIGNOREFILE
        echo "/.warp/docker/dumps"                      >> $GITIGNOREFILE
        echo "/.warp/setup"                             >> $GITIGNOREFILE
        echo "/.warp/lib"                               >> $GITIGNOREFILE
        echo "/.warp/bin"                               >> $GITIGNOREFILE
        echo "/.warp/docker/config/php/ext-xdebug.ini"  >> $GITIGNOREFILE
        echo "/.warp/docker/config/php/ext-ioncube.ini" >> $GITIGNOREFILE
        echo "# FRAMEWORK WARP"                         >> $GITIGNOREFILE
        echo ""                                         >> $GITIGNOREFILE
        
    fi
}

warp_check_rsync_version()
{
    RSYNC_VERSION=$(rsync --version | grep "version" | tr -s ' ' | cut -d ' ' -f 3)

    if (( $(awk 'BEGIN {print ("'$RSYNC_VERSION'" < "'$RSYNC_MINIMUM_VERSION'")}') )); then
        warp_message_warn "Warp Framework require rsync minimum version $RSYNC_MINIMUM_VERSION"
        warp_message_warn "actual version: $RSYNC_VERSION"
        warp_message_warn "should be update rsync"
        warp_message_warn "on MacOS \"brew install rsync\"";
        warp_message_warn "on Debian distribution \"apt-get install rsync\"";
        warp_message  ""

        exit 1
    fi    
}

warp_check_docker_version()
{

    DOCKER_VERSION=$(docker version --format '{{.Server.Version}}')
    DOCKER_COMPOSE_VERSION=$(docker-compose version --short)  

    if (( $(awk 'BEGIN {print ("'$DOCKER_COMPOSE_VERSION'" < "'$DOCKER_COMPOSE_MINIMUM_VERSION'")}') )); then
        warp_message_warn "Warp Framework require docker-compose minimum version $DOCKER_COMPOSE_MINIMUM_VERSION"
        warp_message_warn "actual version: $DOCKER_COMPOSE_VERSION"
        warp_message_warn "should be update docker-compose"
        warp_message  ""
    fi

    if (( $(awk 'BEGIN {print ("'$DOCKER_VERSION'" < "'$DOCKER_MINIMUM_VERSION'")}') )); then
        warp_message_warn "Warp Framework require Docker minimum version $DOCKER_MINIMUM_VERSION"
        warp_message_warn "actual version: $DOCKER_VERSION"
        warp_message_warn "should be update Docker Community Edition"
        warp_message  ""
    fi
}

#!/bin/bash

    # IMPORT HELP

    . "$PROJECTPATH/.warp/bin/reset_help.sh"

function reset_project() 
{

    if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then
        
        reset_help_usage
        exit 1
    fi

    if [ $(warp_check_is_running) = true ]; then
        warp_message_warn "the containers is running";
        warp_message_warn "Please run first warp stop --hard";
        exit 1;
    fi

    if [ "$1" = "--hard" ] ; then
        # reset files TL
        reset_warninig_confirm_hard
    else
        # reset files DEV
        reset_warninig_confirm
    fi;
}

function reset_warninig_confirm_hard()
{
    reset_msj_delete_all=$( warp_question_ask_default "Do you want to delete all project settings? $(warp_message_info [y/N]) " "N" )
    if [ "$reset_msj_delete_all" = "Y" ] || [ "$reset_msj_delete_all" = "y" ]
    then
        confirm_msj_delete_all=$( warp_question_ask_default "$(warp_message_warn 'If you go ahead you must reconfigure the entire project, do you want to continue?') $(warp_message_info [y/N]) " "N" )
        if [ "$confirm_msj_delete_all" = "Y" ] || [ "$confirm_msj_delete_all" = "y" ]
        then
            warp_message "* deleting $(basename $ENVIRONMENTVARIABLESFILE) $(warp_message_ok [ok])"
            warp_message "* deleting $(basename $ENVIRONMENTVARIABLESFILESAMPLE) $(warp_message_ok [ok])"
            warp_message "* deleting $(basename $DOCKERCOMPOSEFILE) $(warp_message_ok [ok])"
            warp_message "* deleting $(basename $DOCKERCOMPOSEFILESAMPLE) $(warp_message_ok [ok])"
            warp_message "* deleting $(basename $DOCKERCOMPOSEFILEMAC) $(warp_message_ok [ok])"
            warp_message "* deleting $(basename $DOCKERCOMPOSEFILEMACSAMPLE) $(warp_message_ok [ok])"
            warp_message "* deleting $(basename $DOCKERSYNCMAC) $(warp_message_ok [ok])"
            warp_message "* deleting $(basename $DOCKERSYNCMACSAMPLE) $(warp_message_ok [ok])"
            warp_message "* deleting $(basename $CHECK_UPDATE_FILE) $(warp_message_ok [ok])"
            warp_message "* deleting $(basename $DOCKERIGNOREFILE) $(warp_message_ok [ok])"
            
            if [ -f $ENVIRONMENTVARIABLESFILE ] 
            then
                case "$(uname -s)" in
                Darwin)
                    USE_DOCKER_SYNC=$(warp_env_read_var USE_DOCKER_SYNC)
                    if [ "$USE_DOCKER_SYNC" = "Y" ] || [ "$USE_DOCKER_SYNC" = "y" ] ; then 
                        # clean data sync
                        docker-sync clean
                    else
                        docker volume rm ${PWD##*/}_${PWD##*/}-volume-sync 2>/dev/null 
                    fi
                ;;
                esac

                DOCKER_PRIVATE_REGISTRY=$(warp_env_read_var DOCKER_PRIVATE_REGISTRY)
                if [ ! -z "$DOCKER_PRIVATE_REGISTRY" ]
                then
                    docker volume rm ${PWD##*/}_${PWD##*/}-volume-db 2>/dev/null 
                fi
                
                rm $ENVIRONMENTVARIABLESFILE 2> /dev/null
            fi

            [ -f $ENVIRONMENTVARIABLESFILESAMPLE ] && rm $ENVIRONMENTVARIABLESFILESAMPLE 2> /dev/null
            [ -f $DOCKERCOMPOSEFILE ] && rm $DOCKERCOMPOSEFILE 2> /dev/null
            [ -f $DOCKERCOMPOSEFILESAMPLE ] && rm $DOCKERCOMPOSEFILESAMPLE 2> /dev/null
            [ -f $DOCKERCOMPOSEFILEMAC ] && rm $DOCKERCOMPOSEFILEMAC 2> /dev/null
            [ -f $DOCKERCOMPOSEFILEMACSAMPLE ] && rm $DOCKERCOMPOSEFILEMACSAMPLE 2> /dev/null
            [ -f $DOCKERSYNCMAC ] && rm $DOCKERSYNCMAC 2> /dev/null
            [ -f $DOCKERSYNCMACSAMPLE ] && rm $DOCKERSYNCMACSAMPLE 2> /dev/null
            [ -f $CHECK_UPDATE_FILE ] && rm $CHECK_UPDATE_FILE 2> /dev/null
            [ -f $DOCKERCOMPOSEFILEDEV ] && rm $DOCKERCOMPOSEFILEDEV 2> /dev/null
            [ -f $DOCKERCOMPOSEFILEDEVSAMPLE ] && rm $DOCKERCOMPOSEFILEDEVSAMPLE 2> /dev/null
            [ -f $DOCKERCOMPOSEFILESELENIUM ] && rm $DOCKERCOMPOSEFILESELENIUM 2> /dev/null
            [ -f $DOCKERIGNOREFILE ] && rm $DOCKERIGNOREFILE 2> /dev/null                

	        rm -rf $PROJECTPATH/.warp/docker/config/* 2> /dev/null

            if [ -d $PROJECTPATH/.warp/docker/volumes ]
            then
                warp_message "* deleting persistence data $(warp_message_ok [ok])"
                sudo rm -rf $PROJECTPATH/.warp/docker/volumes/* 2> /dev/null
            fi

            if [ -d $PROJECTPATH/.platform ]
            then
                warp_message "* deleting sandbox folder $(warp_message_ok [ok])"
                sudo rm -rf $PROJECTPATH/.platform 2> /dev/null

                docker volume rm ${PWD##*/}_${PWD##*/}-volume-sync 2>/dev/null 
                docker volume rm ${PWD##*/}_${PWD##*/}-volume-db 2>/dev/null 
                docker volume rm ${PWD##*/}_2.2.9-ce 2>/dev/null 
                docker volume rm ${PWD##*/}_2.3.1-ce 2>/dev/null 
                docker volume rm ${PWD##*/}_warp-mysql-db 2>/dev/null 
            fi

            if [ -f $GITIGNOREFILE ]
            then
                warp_message "* clearing $(basename $GITIGNOREFILE) $(warp_message_ok [ok])"
                perl -i -p0e 's/# WARP FRAMEWORK.*?# FRAMEWORK WARP//s' $GITIGNOREFILE
            fi

            warp_message ""

            warp_message_warn "files have been deleted, to start again run: $(warp_message_bold './warp init')"
            warp_message ""
        else
            warp_message_warn "* aborting elimination"    
        fi

    fi
}

function reset_warninig_confirm()
{
    reset_msj_delete=$( warp_question_ask_default "Do you want to delete the settings? $(warp_message_info [y/N]) " "N" )
    if [ "$reset_msj_delete" = "Y" ] || [ "$reset_msj_delete" = "y" ]
    then
        warp_message "* deleting $(basename $ENVIRONMENTVARIABLESFILE) $(warp_message_ok [ok])"
        warp_message "* deleting $(basename $DOCKERCOMPOSEFILE) $(warp_message_ok [ok])"
        warp_message "* deleting $(basename $DOCKERCOMPOSEFILEMAC) $(warp_message_ok [ok])"
        warp_message "* deleting $(basename $DOCKERSYNCMAC) $(warp_message_ok [ok])"
        warp_message "* deleting $(basename $DOCKERCOMPOSEFILEDEV) $(warp_message_ok [ok])"

        if [ -f $CONFIGFOLDER/php/ext-xdebug.ini ] || [ -f $CONFIGFOLDER/php/ext-ioncube.ini ]
        then
            warp_message "* reset php configurations files $(warp_message_ok [ok])"
            rm  $CONFIGFOLDER/php/ext-xdebug.ini 2> /dev/null
            rm $CONFIGFOLDER/php/ext-ioncube.ini 2> /dev/null
        elif [ -d $CONFIGFOLDER/php/ext-xdebug.ini ] || [ -d $CONFIGFOLDER/php/ext-ioncube.ini ]
        then
            warp_message "* reset php configurations files $(warp_message_ok [ok])"
            sudo rm -rf $CONFIGFOLDER/php/ext-xdebug.ini 2> /dev/null
            sudo rm -rf $CONFIGFOLDER/php/ext-ioncube.ini 2> /dev/null
        fi
        
        [ -f $ENVIRONMENTVARIABLESFILE ] && rm $ENVIRONMENTVARIABLESFILE 2> /dev/null
        [ -f $DOCKERCOMPOSEFILE ] && rm $DOCKERCOMPOSEFILE 2> /dev/null
        [ -f $DOCKERCOMPOSEFILEMAC ] && rm $DOCKERCOMPOSEFILEMAC 2> /dev/null
        [ -f $DOCKERSYNCMAC ] && rm $DOCKERSYNCMAC 2> /dev/null
        [ -f $DOCKERCOMPOSEFILEDEV ] && rm $DOCKERCOMPOSEFILEDEV 2> /dev/null
        warp_message ""

        warp_message_warn "files have been deleted, to start again run: $(warp_message_bold './warp init')"
        warp_message ""
    fi
}

function reset_main()
{
    case "$1" in
        reset)
            shift 1
            reset_project $*
        ;;

        -h | --help)
            reset_help_usage
        ;;

        *)            
            reset_help_usage
        ;;
    esac
}

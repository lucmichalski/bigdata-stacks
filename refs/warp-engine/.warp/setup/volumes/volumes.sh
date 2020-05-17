warp_message ""
warp_message "* Configuring volumes in containers $(warp_message_ok [ok])"
sleep 1

    if [ ! -z "$docker_private_registry" ]
    then
        cat $PROJECTPATH/.warp/setup/volumes/tpl/volumes.yml >> $DOCKERCOMPOSEFILESAMPLE
    fi    

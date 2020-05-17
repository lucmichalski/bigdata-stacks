#!/bin/bash +x

# LOAD VARIABLES SAMPLE
. $ENVIRONMENTVARIABLESFILESAMPLE

case "$(uname -s)" in
    Darwin)
        while : ; do
            rta_use_docker_sync=$( warp_question_ask_default "Do you want to use docker-sync? $(warp_message_info [y/N]) " "N" )

            if [ "$rta_use_docker_sync" = "Y" ] || [ "$rta_use_docker_sync" = "y" ] || [ "$rta_use_docker_sync" = "N" ] || [ "$rta_use_docker_sync" = "n" ] ; then
                break
            else
                warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
            fi
        done        
    ;;
    *)
        rta_use_docker_sync=Y
    ;;
esac

# Generate sample files
cat $PROJECTPATH/.warp/setup/mac/tpl/docker-compose-warp-mac.yml > $DOCKERCOMPOSEFILEMACSAMPLE
cat $PROJECTPATH/.warp/setup/mac/tpl/docker-sync.yml > $DOCKERSYNCMACSAMPLE

# Get sample from template
if [ "$rta_use_docker_sync" = "Y" ] || [ "$rta_use_docker_sync" = "y" ] ; then
    cat $PROJECTPATH/.warp/setup/mac/tpl/docker-compose-warp-mac.yml > $DOCKERCOMPOSEFILEMAC
else
    if [[ "$FRAMEWORK" = "oro" ]]
    then
        cat $PROJECTPATH/.warp/setup/mac/tpl/docker-mapping-oro-warp-mac.yml > $DOCKERCOMPOSEFILEMAC
    else
        cat $PROJECTPATH/.warp/setup/mac/tpl/docker-mapping-warp-mac.yml > $DOCKERCOMPOSEFILEMAC
    fi
fi

VOLUME_WARP_DEFAULT="warp-volume-sync"
VOLUME_WARP="$(basename $(pwd))-volume-sync"

cat $DOCKERCOMPOSEFILEMAC | sed -e "s/$VOLUME_WARP_DEFAULT/$VOLUME_WARP/" > "$DOCKERCOMPOSEFILEMAC.tmp"
mv "$DOCKERCOMPOSEFILEMAC.tmp" $DOCKERCOMPOSEFILEMAC

cp $DOCKERSYNCMACSAMPLE $DOCKERSYNCMAC

cat $DOCKERSYNCMAC | sed -e "s/$VOLUME_WARP_DEFAULT/$VOLUME_WARP/" > "$DOCKERSYNCMAC.tmp"
mv "$DOCKERSYNCMAC.tmp" $DOCKERSYNCMAC

echo "# Docker Sync" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "USE_DOCKER_SYNC=${rta_use_docker_sync}" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE
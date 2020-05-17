#!/bin/bash +x

warp_message ""
warp_message_info "Configuring Varnish Service"

while : ; do
    respuesta_varnish=$( warp_question_ask_default "Do you want to use varnish service? $(warp_message_info [y/N]) " "N" )

    if [ "$respuesta_varnish" = "Y" ] || [ "$respuesta_varnish" = "y" ] || [ "$respuesta_varnish" = "N" ] || [ "$respuesta_varnish" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

if [ "$respuesta_varnish" = "Y" ] || [ "$respuesta_varnish" = "y" ]
then
    
    if [ ! -d $CONFIGFOLDER/varnish ]
    then
        cp -R $PROJECTPATH/.warp/setup/varnish/config/varnish $CONFIGFOLDER/varnish
    fi;

    warp_message_info2 "You can check the available versions of varnish here $(warp_message_info '[ https://hub.docker.com/r/summasolutions/varnish/tags/ ]')"
    
    while : ; do
        varnish_version=$( warp_question_ask_default "Choose a version of varnish: $(warp_message_info [5.2.1]) " "5.2.1" )
    
        case $varnish_version in
        '4.0.5')
            break
        ;;
        '5.2.1')
            break
        ;;
        *)
            warp_message_info2 "Selected: $varnish_version, the available versions are: 4.0.5, 5.2.1"
        ;;
        esac        
    done
    warp_message_info2 "Selected version of varnish: $varnish_version"    

    cat $PROJECTPATH/.warp/setup/varnish/tpl/varnish.yml >> $DOCKERCOMPOSEFILESAMPLE
fi; 

echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "# VARNISH Configuration" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "USE_VARNISH=$respuesta_varnish" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "VARNISH_VERSION=$varnish_version" >> $ENVIRONMENTVARIABLESFILESAMPLE
echo "" >> $ENVIRONMENTVARIABLESFILESAMPLE    
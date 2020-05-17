#!/bin/bash +x

echo ""
warp_message_info "Configuring Selenium Service"

while : ; do
    respuesta_selenium=$( warp_question_ask_default "Do you want to add selenium service? $(warp_message_info [y/N]) " "N" )

    if [ "$respuesta_selenium" = "Y" ] || [ "$respuesta_selenium" = "y" ] || [ "$respuesta_selenium" = "N" ] || [ "$respuesta_selenium" = "n" ] ; then
        break
    else
        warp_message_warn "wrong answer, you must select between two options: $(warp_message_info [Y/n]) "
    fi
done

if [ "$respuesta_selenium" = "Y" ] || [ "$respuesta_selenium" = "y" ]
then
    cp -R $PROJECTPATH/.warp/setup/selenium/test $PROJECTPATH/.warp/docker/selenium
    
    warp_message_info "Creating file $(basename $DOCKERCOMPOSEFILESELENIUM)"
    cat $PROJECTPATH/.warp/setup/selenium/tpl/docker-selenium-warp.yml > $DOCKERCOMPOSEFILESELENIUM
fi; 
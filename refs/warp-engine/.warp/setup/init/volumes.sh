cat $PROJECTPATH/.warp/setup/init/tpl/appdata.yml >> $DOCKERCOMPOSEFILESAMPLE

cp -R $PROJECTPATH/.warp/setup/init/config/appdata $PROJECTPATH/.warp/docker/config/appdata
cp -R $PROJECTPATH/.warp/setup/init/config/bash $PROJECTPATH/.warp/docker/config/bash
cp -R $PROJECTPATH/.warp/setup/init/config/etc $PROJECTPATH/.warp/docker/config/etc
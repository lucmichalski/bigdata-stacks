#!/bin/sh
#
# Set the correct file permissions for Magento 2

PATH_ROOT_SITE="/var/www/html"
PATH_COMPOSER="/var/www/.composer"

# set correct permission on composer folder
[ -d $PATH_COMPOSER ] && chmod ug+rwx $PATH_COMPOSER
[ -d $PATH_COMPOSER ] && chgrp 33 $PATH_COMPOSER

while true;
do
	# Change group to 33 (www-data inside the container)
	chmod ug+rwx $PATH_ROOT_SITE
	chgrp 33 $PATH_ROOT_SITE	
    
	# Permission to /var/www/html folder
	[ -d $PATH_ROOT_SITE/ ] && chmod -R ug+rw $PATH_ROOT_SITE/*
	[ -d $PATH_ROOT_SITE/ ] && chgrp -R 33 $PATH_ROOT_SITE/*
	[ -d $PATH_ROOT_SITE/vendor ] && chown -R www-data:www-data $PATH_ROOT_SITE/vendor

    # Permission to Magento binary
	if [ -f $PATH_ROOT_SITE/bin/magento ]
    then
		[ -f $PATH_ROOT_SITE/bin/magento ] && chown 33:33 $PATH_ROOT_SITE/bin/magento
		[ -f $PATH_ROOT_SITE/bin/magento ] && chmod +x $PATH_ROOT_SITE/bin/magento
    fi;

    # Permission to Oro binary
	if [ -f $PATH_ROOT_SITE/bin/console ]
    then
		[ -f $PATH_ROOT_SITE/bin/console ] && chown www-data:www-data $PATH_ROOT_SITE/bin/console
		[ -f $PATH_ROOT_SITE/bin/console ] && chmod +x $PATH_ROOT_SITE/bin/console
    elif [ -f $PATH_ROOT_SITE/app/console ] ; then        
		[ -f $PATH_ROOT_SITE/app/console ] && chown www-data:www-data $PATH_ROOT_SITE/app/console
		[ -f $PATH_ROOT_SITE/app/console ] && chmod +x $PATH_ROOT_SITE/app/console
    fi

	# Set permission to warp binary
	[ -f $PATH_ROOT_SITE/warp ] && chmod 775 $PATH_ROOT_SITE/warp

	sleep 3600 # 1 hour
done

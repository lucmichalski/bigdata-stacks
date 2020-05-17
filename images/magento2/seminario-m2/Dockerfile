FROM phusion/baseimage:0.11

LABEL maintainer="Matias Anoniz <matiasanoniz@gmail.com>"

ENV MAGENTO_VERSION 2.3.1
ENV INSTALL_DIR /var/www/html/

RUN mkdir -p $INSTALL_DIR

RUN mkdir -p /tmp/$MAGENTO_VERSION \
  && curl -L http://pubfiles.nexcess.net/magento/ce-packages/magento2-$MAGENTO_VERSION.tar.gz | tar xzf - -o -C /tmp/$MAGENTO_VERSION \
  && mv /tmp/$MAGENTO_VERSION/* /tmp/$MAGENTO_VERSION/.htaccess $INSTALL_DIR

#RUN cd /tmp && \ 
#  curl https://codeload.github.com/magento/magento2/tar.gz/$MAGENTO_VERSION -o $MAGENTO_VERSION.tar.gz && \
#  tar xvf $MAGENTO_VERSION.tar.gz && \
#  mv magento2-$MAGENTO_VERSION/* magento2-$MAGENTO_VERSION/.htaccess $INSTALL_DIR

RUN chown -R www-data:www-data /var/www

RUN cd $INSTALL_DIR \
    && find . -type d -exec chmod 770 {} \; \
    && find . -type f -exec chmod 660 {} \; \
    && chmod +x bin/magento

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR $INSTALL_DIR
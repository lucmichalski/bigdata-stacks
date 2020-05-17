FROM php:7.1-fpm

LABEL maintainer="Matias Anoniz <matiasanoniz@gmail.com>"

ENV PHP_EXTRA_CONFIGURE_ARGS --enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data --enable-intl --enable-opcache --enable-zip

RUN apt-get update

#Install crontab
RUN apt-get install -y cron

RUN update-rc.d cron defaults

RUN \
  apt-get install -y \
  htop \
  mc \
  nano \
  default-mysql-client \
  libcurl4-gnutls-dev \
  libxml2-dev \
  libssl-dev

RUN \
    /usr/local/bin/docker-php-ext-install \
    dom \
    pcntl \
    phar \
    posix

# Configure PHP
# php module build deps
RUN \
  apt-get install -y \
  g++ \
  autoconf \
  libbz2-dev \
  libltdl-dev \
  libjpeg62-turbo-dev \
  libfreetype6-dev \
  libxpm-dev \
  libimlib2-dev \
  libicu-dev \
  libmcrypt-dev \
  libxslt1-dev \
  re2c \
  libpng++-dev \
  libvpx-dev \
  zlib1g-dev \
  libgd-dev \
  libtidy-dev \
  libmagic-dev \
  libexif-dev \
  file \
# libssh2-1-dev \
  libjpeg-dev \
  gnupg \
  git \
  curl \
  vim \
  wget \
  librabbitmq-dev \
  libzip-dev

# https://devdocs.magento.com/guides/v2.3/install-gde/system-requirements-tech.html
RUN \
    /usr/local/bin/docker-php-ext-install \
    pdo \
    sockets \
    pdo_mysql \
    mysqli \
    mbstring \
    mcrypt \
    hash \
    simplexml \
    xsl \
    soap \
    intl \
    bcmath \
    json \
    opcache \
    zip

# Install Node, NVM, NPM and Grunt, Gulp

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - \
    && apt-get install -y nodejs build-essential \
    && curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh \
    && npm i -g grunt-cli yarn \
    && npm install gulp-cli -g

# Magento 2.3.2 
# https://github.com/magento/magento2/issues/23405 
RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list 

RUN apt-get update && apt-get -t stretch-backports install -y \
  libsodium-dev

RUN pecl install -f libsodium-1.0.17 \
  && echo "extension=sodium.so" > /usr/local/etc/php/conf.d/sodium.ini

# ssh2 module
RUN apt-get install -y libssh2-1-dev \
  && pecl install ssh2-1.1.2 \
  && docker-php-ext-enable ssh2

# Install fontforge https://github.com/sapegin/grunt-webfont#installation
RUN apt-get install -y fontforge ttfautohint

# Create .ssh file
RUN mkdir -p /var/www/.ssh

# Set www-data as owner for /var/www
RUN chown -R www-data:www-data /var/www/
RUN chmod -R g+w /var/www/

# Create log folders
RUN rm -rf /var/log/php-fpm # Delete if exist
RUN mkdir -p /var/log/php-fpm && \
    touch /var/log/php-fpm/access.log && \
    touch /var/log/php-fpm/fpm-error.log && \
    touch /var/log/php-fpm/fpm-php.www.log && \
    chown -R www-data:www-data /var/log/php-fpm

RUN wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
  tar -zxf ioncube_loaders_lin_x86-64.tar.gz && \
  mv ioncube/ioncube_loader_lin_7.1.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303/iocube.so && \
  echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20160303/iocube.so" > /usr/local/etc/php/conf.d/10-php-ext-ioncube.ini

RUN wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 && \
    chmod +x mhsendmail_linux_amd64 && \
    mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail

RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr \
    && docker-php-ext-install gd

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

RUN no | pecl install -o -f redis && docker-php-ext-enable redis

# Make sure the volume mount point is empty
RUN rm -rf /var/www/html/* && \
  rm -rf /var/lib/apt/lists/*

# Add users
RUN groupadd -g 501  kirk &&  useradd -g 501  -u 501  -d /var/www/html -s /bin/bash kirk
RUN groupadd -g 1000 warp &&  useradd -g 1000 -u 1000 -d /var/www/html -s /bin/bash warp
RUN groupadd -g 1001 spock && useradd -g 1001 -u 1001 -d /var/www/html -s /bin/bash spock
RUN groupadd -g 1002 scott && useradd -g 1002 -u 1002 -d /var/www/html -s /bin/bash scott

# Add users to group www-data
RUN usermod -aG 501  www-data
RUN usermod -aG 1000 www-data
RUN usermod -aG 1001 www-data
RUN usermod -aG 1002 www-data

RUN pecl install -o -f xdebug-2.6.1

RUN chmod a+x /usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so 
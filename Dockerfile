# start from php 7.3.5, apache based on debian linux
FROM php:7.4.2-apache-buster
# credits goes here
LABEL maintainer="Oceanize Inc<www.oceanize.co.jp>"
# disable interactive mode
ENV DEBIAN_FRONTEND noninteractive

# install common tools
RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++ \
libpng-dev libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev \
libfreetype6-dev
# install php intl extension
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
# install pdo_mysql library
RUN docker-php-ext-configure pdo_mysql
RUN docker-php-ext-install pdo_mysql
# install mysqli library
RUN docker-php-ext-configure mysqli
RUN docker-php-ext-install mysqli
# install gd library
RUN docker-php-ext-configure gd
RUN docker-php-ext-install gd
# copy the apache config file
COPY config/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
# change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
COPY config/apache/apache2.conf /etc/apache2/apache2.conf
# copy the PHP ini settings
COPY config/php/* /usr/local/etc/php/conf.d/
# enable mod-rewrite
RUN a2enmod rewrite
# RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# install zip extension
RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-configure zip \
  && docker-php-ext-install zip

# restart apache
RUN service apache2 restart

# Install ImageMagick
RUN apt-get install -y imagemagick
# Install PHP Imagick
RUN apt-get install -y libmagickcore-dev
RUN apt-get install -y libmagickwand-dev
RUN pecl install imagick
RUN docker-php-ext-enable imagick

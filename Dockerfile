FROM php:7.4.2-cli-buster
LABEL author="Syed Mazhar Ahmed"
LABEL maintainer="Oceanize Inc<www.oceanize.co.jp>"
LABEL oceanize="true"

# install git and other tools
RUN apt-get update -y && apt-get install -y openssl unzip git

# install common tools
RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++
# install php intl extension
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
# install pdo_mysql library
RUN docker-php-ext-configure pdo_mysql
RUN docker-php-ext-install pdo_mysql
# install mysqli library
RUN docker-php-ext-configure mysqli
RUN docker-php-ext-install mysqli
# install git
RUN apt-get install -y libz-dev libmemcached-dev
RUN pecl install memcached
RUN echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini

# install zip extension
RUN apt-get install -y \
        libzip-dev \
        zip \
  && docker-php-ext-configure zip \
  && docker-php-ext-install zip

# copy the PHP ini settings
COPY config/php/* /usr/local/etc/php/conf.d/

# Install ImageMagick
RUN apt-get install -y imagemagick
# Install PHP Imagick
RUN apt-get install -y libmagickcore-dev
RUN apt-get install -y libmagickwand-dev
RUN pecl install imagick
RUN docker-php-ext-enable imagick

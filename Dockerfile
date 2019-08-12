FROM php:7.3-apache

RUN curl  -o /usr/bin/phpunit -L "https://phar.phpunit.de/phpunit-8.1.phar" \
    && chmod +x /usr/bin/phpunit \
    && apt-get update \
    && apt-get install -y sudo \
    && apt-get install -y git \
    && apt-get install -y gnupg \
    && apt-get install -y libtidy-dev \
    && apt-get install -y libcurl4-openssl-dev \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && apt-get install -y libxml2-dev libxslt-dev \
    && apt-get install -y mysql-client \
    && docker-php-ext-configure curl \
    && docker-php-ext-configure mysqli \
    && docker-php-ext-configure pdo \
    && docker-php-ext-configure soap \
    && docker-php-ext-configure xsl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure tidy \
    && docker-php-ext-install curl mysqli pdo soap xsl gd tidy \
    && a2enmod rewrite \
    && mkdir -p /swcombine/htdocs/code/ \
    && mkdir -p /swcombine/htdocs/images.swcombine.com/ \
    && mkdir -p /tmp/feeds/ \
    && chown www-data /tmp/feeds/ \
    && touch /tmp/feeds/gns_flashnews.xml \
    && chown www-data /tmp/feeds/gns_flashnews.xml \
    && (curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -) \
    && apt-get install -y nodejs \
    && npm install -g less \
    && npm install -g less-plugin-clean-css \
    && npm install -g db-migrate \
    && npm install -g db-migrate-mysql

ADD php.ini /usr/local/etc/php/php.ini
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
WORKDIR /swcombine/htdocs/code/


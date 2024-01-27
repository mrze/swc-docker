FROM php:7.3-apache

RUN curl -s -o /usr/bin/phpunit -L "https://phar.phpunit.de/phpunit-8.1.phar" \
    && chmod +x /usr/bin/phpunit \
    && mkdir -p /etc/apt/keyrings \
    && apt-get update \
    && apt-get install -y sudo ca-certificates zip unzip git curl gnupg libtidy-dev libcurl4-openssl-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxml2-dev libxslt-dev mariadb-client \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && docker-php-ext-configure curl \
    && docker-php-ext-configure mysqli \
    && docker-php-ext-configure pdo \
    && docker-php-ext-configure soap \
    && docker-php-ext-configure xsl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure tidy \
    && docker-php-ext-install curl mysqli pdo soap xsl gd tidy opcache \
    && pecl install xdebug-3.1.5 \
    && docker-php-ext-enable xdebug \
    && mkdir -p /swcombine/htdocs/code/ \
    && mkdir -p /swcombine/htdocs/images.swcombine.com/ \
    && mkdir -p /tmp/feeds/ \
    && chown www-data /tmp/feeds/ \
    && touch /tmp/feeds/gns_flashnews.xml \
    && chown www-data /tmp/feeds/gns_flashnews.xml \
    && apt-get install -y nodejs \
    && npm install -g less \
    && npm install -g less-plugin-clean-css \
    && npm install -g db-migrate \
    && npm install -g db-migrate-mysql \
    && a2enmod rewrite \
    && a2enmod remoteip \
    && git config --system --add safe.directory "*" \
    && mkdir -p /swcombine/htdocs/logs/

ADD php.ini /usr/local/etc/php/php.ini
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
WORKDIR /swcombine/htdocs/code/


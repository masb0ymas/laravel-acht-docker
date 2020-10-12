FROM webdevops/php-nginx:7.3-alpine
RUN docker-php-ext-install pdo mbstring sockets opcache
RUN apk add --no-cache \
	$PHPIZE_DEPS \
	openssl-dev

# Setup Timezone
RUN	apk add tzdata
ENV TZ=Asia/Jakarta
ENV WEB_DOCUMENT_ROOT=/var/www/public

# Setup GD extension
RUN apk update && apk add libpng-dev 
RUN apk add libwebp-dev \
	libpng-dev libxpm-dev \
	freetype-dev \
	libjpeg-turbo-dev 

RUN docker-php-ext-configure gd \
	--with-gd \
	--with-webp-dir \
	--with-jpeg-dir \
	--with-png-dir \
	--with-zlib-dir \
	--with-xpm-dir \
	--with-freetype-dir

RUN docker-php-ext-install gd

RUN apk add --no-cache zip libzip-dev
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip

RUN apk add libxslt-dev
RUN docker-php-ext-install xsl

# RUN pecl install mongodb && rm -rf /tmp/pear
# RUN pecl install redis && rm -rf /tmp/pear
RUN docker-php-ext-enable redis

# COPY ./php.ini $PHP_INI_DIR/php.ini
# COPY ./application.conf /opt/docker/etc/php/fpm/pool.d/application.conf
# COPY ./nginx.conf /opt/docker/etc/nginx/nginx.conf
# COPY ./vhost.conf /opt/docker/etc/nginx/vhost.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . /var/www
WORKDIR /var/www
RUN chown -R application:application .

# using composer.phar v1
# RUN composer install
# RUN composer update

# using composer.phar v2
RUN php composer.phar install
# RUN php composer.phar update

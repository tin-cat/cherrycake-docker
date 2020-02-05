FROM php:7.4-fpm

ARG USER_ID
ARG GROUP_ID

# Re-create www-data user and group to be the specified USER_ID and GROUP_ID to solve permission problems
RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    userdel -f www-data &&\
    if getent group www-data ; then groupdel www-data; fi &&\
    groupadd -g ${GROUP_ID} www-data &&\
    useradd -l -u ${USER_ID} -g www-data -d /app -s /usr/sbin/nologin www-data &&\
    install -d -m 0755 -o www-data -g www-data /app/public &&\
    chown --changes --silent --no-dereference --recursive --from=33:33 ${USER_ID}:${GROUP_ID} /app/public \
    ;fi

# Uncomment the one to use, either production or development
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer

# The libonig replaces mbstring
RUN apt-get update &&\
    apt-get install -y \
	git \
	libjpeg62-turbo-dev \
	libpng-dev \
    zip \
    unzip \
    libxml2-dev \
	libonig-dev \
	openssl \
	curl \
	libcurl4-openssl-dev \
	&& docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install pdo_mysql mysqli json curl xml opcache exif

RUN printf '[PHP]\ndate.timezone = "UTC"\n' > /usr/local/etc/php/conf.d/tzone.ini

# Install APCu
RUN pecl install APCu-5.1.18
RUN docker-php-ext-enable apcu
RUN echo "extension=apcu.so" >> /usr/local/etc/php/php.ini
RUN echo "apc.enable_cli=1" >> /usr/local/etc/php/php.ini
RUN echo "apc.enable=1" >> /usr/local/etc/php/php.ini

USER ${USER_ID}:${GROUP_ID}

WORKDIR /var/www/app
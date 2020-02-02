FROM alpine:3.8

# Environments
ENV LD_PRELOAD=/usr/lib/preloadable_libiconv.so\ php \
    APP_DIR=/var/www/web \
    TIMEZONE=Europe/Berlin \
    PHP_MEMORY_LIMIT=24M \
    PHP_PORT=9000 \
    PHP_PM=dynamic \
    PHP_PM_MAX_CHILDREN=10 \
    PHP_PM_START_SERVERS=4 \
    PHP_PM_MIN_SPARE_SERVERS=2 \
    PHP_PM_MAX_SPARE_SERVERS=6 \
    PHP_SERIALIZE_PRECISION=17\
    PHP_MAX_EXECUTION_TIME=30\
    PHP_DISPLAY_ERRORS=Off \
    PHP_DISPLAY_STARTUP_ERRORS=Off \
    PHP_POST_MAX_SIZE=12M \
    PHP_UPLOAD_MAX_FILESIZE=12M \
    PHP_MAX_FILE_UPLOADS=20 \
    PHP_SESSION_NAME=SESSION \
    PHP_ROOT=/var/ \
    PHP_SMTP_SERVER=smtp.mailgun.org \
    PHP_SMTP_USER=xx \
    PHP_SMTP_PASS=xx

ADD entrypoint.sh ./
ADD docker/etc/crontabs/root /etc/crontabs/root

RUN apk add --update \
        tzdata \
		&& cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
		&& echo "${TIMEZONE}" >  /etc/timezone \
		&& apk add --update \
		yarn \
        bash \
        dumb-init \
		fail2ban \
		git \
        imagemagick \
        mc \
        openssh \
        php7 \
        php7-ctype \
        php7-curl \
        php7-fileinfo \
        php7-fpm \
        php7-ftp \
        php7-gd \
        php7-iconv \
        php7-imagick \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-openssl \
        php7-pdo_mysql \
        php7-pdo_sqlite \
        php7-phar \
        php7-session \
        php7-simplexml \
        php7-soap \
        php7-tokenizer \
        php7-xml \
        php7-xmlrpc \
		php7-xmlwriter \
		php7-xsl \
		php7-zip \
		php7-zlib \
		&& sed -i "s|;*date.timezone =.*|date.timezone = \${TIMEZONE}|i" /etc/php7/php.ini \
		&& sed -i "s|;*session.name =.*|session.name = \${PHP_SESSION_NAME}|i" /etc/php7/php.ini \
		&& sed -i "s|;*memory_limit =.*|memory_limit = \${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini \
		&& sed -i "s|;*max_execution_time =.*|max_execution_time = \${PHP_MAX_EXECUTION_TIME}|i" /etc/php7/php.ini \
		&& sed -i "s|;*serialize_precision =.*|serialize_precision = \${PHP_SERIALIZE_PRECISION}|i" /etc/php7/php.ini \
		&& sed -i "s|;*display_errors =.*|display_errors = \${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini \
		&& sed -i "s|;*display_startup_errors =.*|display_startup_errors = \${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini \
		&& sed -i "s|;*post_max_size =.*|post_max_size = \${PHP_POST_MAX_SIZE}|i" /etc/php7/php.ini \
		&& sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = \${PHP_UPLOAD_MAX_FILESIZE}|i" /etc/php7/php.ini \
		&& sed -i "s|;*max_file_uploads =.*|max_file_uploads = \${PHP_MAX_FILE_UPLOADS}|i" /etc/php7/php.ini \
		&& sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = \${PHP_PORT}|g" /etc/php7/php-fpm.d/www.conf \
		&& sed -i "s|;*pm\s*=\s*.*|pm = \${PHP_PM}|g" /etc/php7/php-fpm.d/www.conf \
		&& sed -i "s|;*pm.max_children\s*=\s*.*|pm.max_children = \${PHP_PM_MAX_CHILDREN}|g" /etc/php7/php-fpm.d/www.conf \
		&& sed -i "s|;*pm.start_servers\s*=\s*.*|pm.start_servers = \${PHP_PM_START_SERVERS}|g" /etc/php7/php-fpm.d/www.conf \
		&& sed -i "s|;*pm.min_spare_servers\s*=\s*.*|pm.min_spare_servers = \${PHP_PM_MIN_SPARE_SERVERS}|g" /etc/php7/php-fpm.d/www.conf \
		&& sed -i "s|;*pm.max_spare_servers\s*=\s*.*|pm.max_spare_servers = \${PHP_PM_MAX_SPARE_SERVERS}|g" /etc/php7/php-fpm.d/www.conf \
		&& sed -i "s|;*clear_env\s*=\s*no|clear_env = no|g" /etc/php7/php-fpm.d/www.conf \
		&& sed -i "s|;*sendmail_path =.*|sendmail_path = sendmail -t -f \${PHP_SMTP_USER} -S \${PHP_SMTP_SERVER} -au\${PHP_SMTP_USER} -ap\${PHP_SMTP_PASS}|i" /etc/php7/php.ini \
		## cleanup
		&& apk del tzdata \
		&& rm -rf /var/cache/apk/* \
		&& rm /etc/crontabs/root \
		## SETUP
		&& ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm \
		&& sed -i "s/user = nobody/user = www-data/" /etc/php7/php-fpm.d/www.conf \
        && sed -i "s/group = nobody/group = www-data/" /etc/php7/php-fpm.d/www.conf \
        && set -x \
        && addgroup -g 82 -S www-data \
        && adduser -u 82 -s /bin/bash -D -G www-data www-data \
        && chmod +x /entrypoint.sh \
        && mkdir -p $APP_DIR && chown -R www-data:www-data $APP_DIR \
        # Install composer to path
        && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
        php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
        php -r "unlink('composer-setup.php');" && \
        chmod +x /usr/local/bin/composer && \
        composer self-update \
        && composer global require hirak/prestissimo \
        && su www-data -c "composer global require hirak/prestissimo"

WORKDIR $APP_DIR
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint.sh"]

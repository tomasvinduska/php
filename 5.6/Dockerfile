FROM alpine:3.5

RUN apk add --update \
        dumb-init \
		bash \
		php5 \
		php5-fpm \
		php5-curl \
		php5-intl \
		php5-mcrypt \
		php5-json \
		php5-iconv \
		php5-openssl \
		php5-ctype \
		php5-phar \
		php5-xml \
		php5-gd \
		php5-xsl \
		php5-xml \
		php5-soap \
		php5-zip \
		php5-pdo_mysql \
		tzdata \
		mc

RUN rm -rf /var/cache/apk/*
RUN sed -i "s|;*listen\s*=\s*127.0.0.1:9000|listen = 9000|g" /etc/php5/php-fpm.conf
RUN cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime

CMD ["php-fpm","-F"]
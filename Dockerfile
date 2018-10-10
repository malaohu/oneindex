FROM php:fpm-alpine
WORKDIR /var/www/html
COPY / /var/www/html/
RUN apk add --no-cache nginx \
    && mkdir /run/nginx \
    && chown -R www-data:www-data cache/ config/ \
    && mv default.conf /etc/nginx/conf.d \
    && mv php.ini /usr/local/etc/php \
    && sed -i 's/^$/*\/10 * * * * \/usr\/local\/bin\/php \/var\/lib\/nginx\/html\/one.php cache:refresh/g'  /var/spool/cron/crontabs/root

EXPOSE 80
# Persistent config file and cache
VOLUME [ "/var/www/html/config", "/var/www/html/cache" ]

CMD php-fpm & \
    ginx -g "daemon off;"

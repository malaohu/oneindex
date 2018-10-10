FROM php:fpm-alpine
WORKDIR /var/www/html
COPY / /var/www/html/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update\
    && apk add --no-cache nginx \
    && mkdir /run/nginx \
    && chown -R www-data:www-data cache/ config/ \
    && mv default.conf /etc/nginx/conf.d \
    && mv php.ini /usr/local/etc/php \
    && sed -i '/^$/d' /var/spool/cron/crontabs/root \
    && echo '*/10 * * * * /usr/local/bin/php /var/www/html/one.php cache:refresh' >> /var/spool/cron/crontabs/root  \
    && echo '0 * * * *  /usr/local/bin/php /var/www/html/one.php token:refresh' >> /var/spool/cron/crontabs/root 

EXPOSE 80
# Persistent config file and cache
VOLUME [ "/var/www/html/config", "/var/www/html/cache" ]

CMD php-fpm & \
    nginx -g "daemon off;"

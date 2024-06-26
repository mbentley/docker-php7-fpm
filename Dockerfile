# rebased/repackaged base image that only updates existing packages
FROM mbentley/alpine:3.15
LABEL maintainer="Matt Bentley <mbentley@mbentley.net>"

# install typical php packages and then additional packages
RUN apk add --no-cache bind-tools imagemagick php7 php7-bcmath php7-bz2 php7-ctype php7-curl php7-exif php7-fileinfo php7-gd php7-fpm php7-gettext php7-gmp php7-iconv php7-imagick php7-intl php7-imap php7-json php7-ldap php7-mbstring php7-mcrypt php7-memcached php7-mysqli php7-pecl-apcu php7-pecl-igbinary php7-pecl-imagick php7-pecl-redis php7-pdo php7-pdo_mysql php7-opcache php7-pdo_pgsql php7-pgsql php7-pcntl php7-posix php7-simplexml php7-xml php7-xmlreader php7-xmlwriter php7-zip ssmtp wget whois &&\
  sed -i "s#listen = 127.0.0.1:9000#listen = /var/run/php/php-fpm7.sock#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^user = nobody#user = www-data#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^group = nobody#group = www-data#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.owner = nobody#listen.owner = www-data#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.group = nobody#listen.group = www-data#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^;listen.mode = 0660#listen.mode = 0660#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^;env#env#g" /etc/php7/php-fpm.d/www.conf &&\
  sed -i "s#^;opcache.enable=1#opcache.enable=1#g" /etc/php7/php.ini &&\
  sed -i "s#^;opcache.interned_strings_buffer=8#opcache.interned_strings_buffer=32#g" /etc/php7/php.ini &&\
  sed -i "s#^;opcache.max_accelerated_files=10000#opcache.max_accelerated_files=25000#g" /etc/php7/php.ini &&\
  sed -i "s#^;opcache.memory_consumption=128#opcache.memory_consumption=256#g" /etc/php7/php.ini &&\
  sed -i "s#^;opcache.save_comments=1#opcache.save_comments=1#g" /etc/php7/php.ini &&\
  sed -i "s#^;opcache.revalidate_freq=2#opcache.revalidate_freq=30#g" /etc/php7/php.ini &&\
  echo 'apc.enable_cli=1' >> /etc/php7/conf.d/apcu.ini &&\
  (deluser "$(grep ':33:' /etc/passwd | awk -F ':' '{print $1}')" || true) &&\
  (delgroup "$(grep '^www-data:' /etc/group | awk -F ':' '{print $1}')" || true) &&\
  mkdir /var/www &&\
  addgroup -g 33 www-data &&\
  adduser -D -u 33 -G www-data -s /sbin/nologin -H -h /var/www www-data &&\
  chown -R www-data:www-data /var/www

# add entrypoint script
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/php-fpm7","-F","--fpm-config","/etc/php7/php-fpm.conf"]

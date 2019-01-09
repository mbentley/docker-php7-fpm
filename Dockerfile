FROM alpine:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

# install typical php packages and then additional packages
RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories &&\
  apk add --no-cache bind-tools imagemagick@edge php7-curl php7-gd php7-fpm php7-imagick php7-mcrypt php7-memcached php7-mysqli ssmtp wget whois &&\
  sed -i "s#listen = 127.0.0.1:9000#listen = /var/run/php/php-fpm7.sock#g" /etc/php7/php-fpm.d/www.conf

# add entrypoint script
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/php-fpm7","-F","--fpm-config","/etc/php7/php-fpm.conf"]

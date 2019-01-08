FROM debian:stretch
MAINTAINER Matt Bentley <mbentley@mbentley.net>

# install typical php packages and then additional packages
RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y php7.0-curl php7.0-gd php7.0-fpm php-imagick php7.0-mcrypt php-memcache php-memcached php7.0-mysql dnsutils imagemagick netbase ssmtp whois &&\
  rm -rf /var/lib/apt/lists/* &&\
  mkdir /run/php

# add run script
ADD run.sh /usr/local/bin/run

ENTRYPOINT ["/usr/local/bin/run"]
CMD ["/usr/sbin/php-fpm7.0","-F","-R","--fpm-config","/etc/php/7.0/fpm/php-fpm.conf"]

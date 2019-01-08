#!/bin/bash

MAX_SIZE=${MAX_SIZE:-8}
MAX_CHILDREN=${MAX_CHILDREN:-5}
LISTEN=${LISTEN:-socket}

if [ ! -d /run/php ]
then
  mkdir /run/php
fi

if [ ! -f /tmp/configured ]
then
  if [ ! "${MAX_SIZE}" = "8" ]
  then
    echo "Setting 'post_max_size' and 'upload_max_filesize' to '${MAX_SIZE}'"
    sed -i "s/post_max_size = 8M/post_max_size = ${MAX_SIZE}M/g" /etc/php/7.0/fpm/php.ini
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = ${MAX_SIZE}M/g" /etc/php/7.0/fpm/php.ini
  else
    echo "Using default value '${MAX_SIZE}' for 'post_max_size' and 'upload_max_filesize'"
  fi

  if [ ! "${MAX_CHILDREN}" = "5" ]
  then
    echo "Setting 'max_children' to '${MAX_CHILDREN}'"
    sed -i "s/pm.max_children = 5/pm.max_children = ${MAX_CHILDREN}/g" /etc/php/7.0/fpm/pool.d/www.conf
  else
    echo "Using default value '${MAX_CHILDREN}' for 'pm.max_children'"
  fi

  if [ "${LISTEN}" = "port" ]
  then
    echo "Disabling UNIX socket; enabling listening on TCP port 9000"
    sed -i "s/listen = \/run\/php\/php7.0-fpm.sock/listen = 9000/g" /etc/php/7.0/fpm/pool.d/www.conf
  else
    echo "Using default value '/run/php/php7.0-fpm.sock' for 'listen'"
  fi

  touch /tmp/configured
  echo "Configuration complete."
fi

exec "$@"

#!/bin/sh
set -e
docker exec -it -w /var/www/html/app ascs-app composer  install --no-interaction

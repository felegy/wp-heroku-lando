#!/bin/sh
vendor/bin/heroku-php-nginx -i config/php/custom_php.ini -C config/nginx.conf web/

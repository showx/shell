#!/bin/bash
echo '#####mysql#####'
#sudo
sudo /usr/local/mysql/bin/mysqld
echo '#####php######'
php-fpm
echo '#####nginx######'
nginx

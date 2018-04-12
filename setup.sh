#!/bin/bash
yum -y install gawk bc wget lsof
. env.sh
. get-info.sh
. prepare.sh
. php.sh
. opcache.sh
. nginx.sh
. mariadb.sh
#. change-port.sh
. chown-server.sh

#Install phpmyadmin
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

cd /home/$server_name/private_html/
git clone https://github.com/phpmyadmin/phpmyadmin.git
cd phpmyadmin
composer update --no-dev

cd ..
git clone https://github.com/shevabam/ezservermonitor-web.git

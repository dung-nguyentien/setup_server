#!/usr/bin/env bash
#Install phpmyadmin
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

cd /home/$server_name/private_html/
git clone https://github.com/phpmyadmin/phpmyadmin.git
cd phpmyadmin
composer update --no-dev

cd /home/$server_name/private_html/
git clone https://github.com/shevabam/ezservermonitor-web.git

cd /home/$server_name/private_html/
git clone https://github.com/PeeHaa/OpCacheGUI.git
cd OpCacheGUI
echo "$(<other/config-opcache-ui.php)" > config.php

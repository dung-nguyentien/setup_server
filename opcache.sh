#!/usr/bin/env bash

# Zend Opcache
opcache_path='opcache.so' #Default for PHP 5.5 and newer

wget -q https://raw.github.com/amnuts/opcache-gui/master/index.php -O /home/$server_name/private_html/op.php
cat > /etc/php.d/*opcache*.ini <<END
zend_extension=$opcache_path
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=4000
opcache.max_wasted_percentage=5
opcache.use_cwd=1
opcache.validate_timestamps=1
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.blacklist_filename=/etc/php.d/opcache-default.blacklist
END

cat > /etc/php.d/opcache-default.blacklist <<END
/home/$server_name/private_html/
END

systemctl restart php-fpm.service
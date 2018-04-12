#!/usr/bin/env bash
# Nginx #
echo "$(<nginx/nginx.conf)" > /etc/nginx/nginx.conf
sed -i "s/\$cpu_cores/$cpu_cores/g" /etc/nginx/nginx.conf

echo "$(<nginx/403.html)" > /usr/share/nginx/html/403.html
echo "$(<nginx/404.html)" > /usr/share/nginx/html/404.html

rm -rf /etc/nginx/conf.d/*
> /etc/nginx/conf.d/default.conf

server_name_alias="www.$server_name"
if [[ $server_name == *www* ]]; then
    server_name_alias=${server_name/www./''}
fi

sed -i "s/\$server_name/$server_name/g" /etc/nginx/conf.d/$server_name.conf
sed -i "s/\$admin_port/$admin_port/g" /etc/nginx/conf.d/$server_name.conf
sed -i "s/\$server_ip/$server_ip/g" /etc/nginx/conf.d/$server_name.conf
sed -i "s/\$server_name_alias/$server_name_alias/g" /etc/nginx/conf.d/$server_name.conf

echo "$(<nginx/limits.conf)" > /etc/security/limits.conf

ulimit -n 262144

printf "admin:$(openssl passwd -apr1 $admin_password)\n" > /home/$server_name/private_html/security/.htpasswd

systemctl restart nginx.service
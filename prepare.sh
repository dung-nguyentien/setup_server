#!/usr/bin/env bash
clear
printf "=========================================================================\n"
printf "Chuan bi qua trinh cai dat... \n"
printf "=========================================================================\n"


rm -f /etc/localtime
ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

if [ -s /etc/selinux/config ]; then
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
fi
setenforce 0

# Install EPEL + Remi Repo
yum -y install epel-release yum-utils
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# Install Nginx Repo
rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

# Install MariaDB Repo 10.0
cat > "/etc/yum.repos.d/MariaDB.repo" <<END
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
END

systemctl stop  saslauthd.service
systemctl disable saslauthd.service

yum -y remove mysql* php* httpd* sendmail* postfix* rsyslog*
yum clean all
yum -y update

clear
printf "=========================================================================\n"
printf "Chuan bi xong, bat dau cai dat server... \n"
printf "=========================================================================\n"
sleep 3


# Install Nginx, PHP-FPM and modules

# Enable Remi Repo
yum-config-manager --enable remi
yum-config-manager --enable remi-php72
yum -y install nginx php-fpm php-common php-gd php-mysqlnd php-pdo php-xml php-mbstring php-mcrypt php-curl php-opcache php-cli php-pecl-zip

# Install MariaDB
yum -y install MariaDB-server MariaDB-client

# Install Others
yum -y install exim syslog-ng syslog-ng-libdbi cronie fail2ban unzip zip nano openssl ntpdate

ntpdate asia.pool.ntp.org
hwclock --systohc

clear
printf "=========================================================================\n"
printf "Cai dat xong, bat dau cau hinh server... \n"
printf "=========================================================================\n"
sleep 3

# Autostart
systemctl enable nginx.service
systemctl enable php-fpm.service
systemctl enable mysql.service # Failed to execute operation: No such file or directory
systemctl enable fail2ban.service

mkdir -p /home/$server_name/public_html
mkdir /home/$server_name/private_html
mkdir /home/$server_name/logs
chmod 777 /home/$server_name/logs

mkdir -p /var/log/nginx
chown -R nginx:nginx /var/log/nginx
chown -R nginx:nginx /var/lib/php/session

echo "<?php phpinfo(); ?>" >/home/$server_name/public_html/index.php

systemctl start nginx.service
systemctl start php-fpm.service
systemctl start mysql.service
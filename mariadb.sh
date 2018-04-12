#!/usr/bin/env bash
# MariaDB #
# set /etc/my.cnf templates from Centmin Mod
cp /etc/my.cnf /etc/my.cnf-original

if [[ "$(expr $server_ram_total \<= 2099000)" = "1" ]]; then
	echo "$(<mariadb/my-mdb10-min.cnf)" > /etc/my.cnf
fi

if [[ "$(expr $server_ram_total \> 2100001)" = "1" && "$(expr $server_ram_total \<= 4190000)" = "1" ]]; then
	# echo -e "\nCopying MariaDB my-mdb10.cnf file to /etc/my.cnf\n"
	echo "$(<mariadb/my-mdb10.cnf)" > /etc/my.cnf
fi

if [[ "$(expr $server_ram_total \>= 4190001)" = "1" && "$(expr $server_ram_total \<= 8199999)" = "1" ]]; then
	echo "$(<mariadb/my-mdb10-4gb.cnf)" > /etc/my.cnf
fi

if [[ "$(expr $server_ram_total \>= 8200000)" = "1" && "$(expr $server_ram_total \<= 15999999)" = "1" ]]; then
	echo "$(<mariadb/my-mdb10-8gb.cnf )" > /etc/my.cnf
fi

if [[ "$(expr $server_ram_total \>= 16000000)" = "1" && "$(expr $server_ram_total \<= 31999999)" = "1" ]]; then
	echo "$(<mariadb/my-mdb10-16gb.cnf)" > /etc/my.cnf
fi

if [[ "$(expr $server_ram_total \>= 32000000)" = "1" ]]; then
	echo "$(<mariadb/my-mdb10-32gb.cnf)" > /etc/my.cnf
fi

sed -i "s/server_name_here/$server_name/g" /etc/my.cnf

rm -f /var/lib/mysql/ib_logfile0
rm -f /var/lib/mysql/ib_logfile1
rm -f /var/lib/mysql/ibdata1

clear
printf "=========================================================================\n"
printf "Thiet lap co ban cho MariaDB ... \n"
printf "=========================================================================\n"
sleep 1
'/usr/bin/mysqladmin' -u root password "$root_password"
mysql -u root -p"$root_password" -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' IDENTIFIED BY '$admin_password' WITH GRANT OPTION;"
mysql -u root -p"$root_password" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost')"
mysql -u root -p"$root_password" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$root_password" -e "DROP User '';"
mysql -u root -p"$root_password" -e "DROP DATABASE test"
mysql -u root -p"$root_password" -e "FLUSH PRIVILEGES"

cat > "/root/.my.cnf" <<END
[client]
user=root
password=$root_password
END
chmod 600 /root/.my.cnf

# Fix MariaDB 10
systemctl stop mysql.service

rm -rf /var/lib/mysql/mysql/gtid_slave_pos.ibd
rm -rf /var/lib/mysql/mysql/innodb_table_stats.ibd
rm -rf /var/lib/mysql/mysql/innodb_index_stats.ibd

systemctl start mysql.service

mysql -e "ALTER TABLE mysql.gtid_slave_pos DISCARD TABLESPACE;" 2> /dev/null
mysql -e "ALTER TABLE mysql.innodb_table_stats DISCARD TABLESPACE;" 2> /dev/null
mysql -e "ALTER TABLE mysql.innodb_index_stats DISCARD TABLESPACE;" 2> /dev/null

mysql mysql < mariadb/mariadb10_3tables.sql

systemctl restart mysql.service
mysql_upgrade --force mysql
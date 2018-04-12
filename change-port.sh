#!/usr/bin/env bash
# Change port SSH
sed -i "s/#Port 22/Port $ssh_port/g" /etc/ssh/sshd_config

cat > "/etc/fail2ban/jail.local" <<END
[sshd]
enabled  = true
filter   = sshd
action   = iptables[name=SSH, port=$ssh_port, protocol=tcp]
logpath  = /var/log/secure
maxretry = 3
bantime = 3600

[nginx-http-auth]
enabled = true
filter = nginx-http-auth
action = iptables[name=NoAuthFailures, port=$admin_port, protocol=tcp]
logpath = /home/$server_name/logs/nginx_error.log
maxretry = 3
bantime = 3600
END

systemctl start fail2ban.service

# Open port
systemctl start firewalld
systemctl enable firewalld
if [[ `firewall-cmd --state` = running ]]; then
	firewall-cmd --zone=public --add-port=80/tcp --permanent
	firewall-cmd --zone=public --add-port=25/tcp --permanent
	firewall-cmd --zone=public --add-port=443/tcp --permanent
	firewall-cmd --zone=public --add-port=465/tcp --permanent
	firewall-cmd --zone=public --add-port=587/tcp --permanent
	firewall-cmd --zone=public --add-port=$admin_port/tcp --permanent
	firewall-cmd --zone=public --add-port=$ssh_port/tcp --permanent
	firewall-cmd --reload
fi

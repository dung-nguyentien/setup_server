#!/usr/bin/env bash
# Log Rotation
cat > "/etc/logrotate.d/nginx" <<END
/home/*/logs/access.log /home/*/logs/error.log /home/*/logs/nginx_error.log {
	create 640 nginx nginx
        daily
	dateext
        missingok
        rotate 5
        maxage 7
        compress
	size=100M
        notifempty
        sharedscripts
        postrotate
                [ -f /var/run/nginx.pid ] && kill -USR1 \`cat /var/run/nginx.pid\`
        endscript
	su nginx nginx
}
END
cat > "/etc/logrotate.d/php-fpm" <<END
/home/*/logs/php-fpm*.log {
        daily
	dateext
        compress
        maxage 7
        missingok
        notifempty
        sharedscripts
        size=100M
        postrotate
            /bin/kill -SIGUSR1 \`cat /var/run/php-fpm/php-fpm.pid 2>/dev/null\` 2>/dev/null || true
        endscript
	su nginx nginx
}
END
cat > "/etc/logrotate.d/mysql" <<END
/home/*/logs/mysql*.log {
        create 640 mysql mysql
        notifempty
        daily
        rotate 3
        maxage 7
        missingok
        compress
        postrotate
        # just if mysqld is really running
        if test -x /usr/bin/mysqladmin && \
           /usr/bin/mysqladmin ping &>/dev/null
        then
           /usr/bin/mysqladmin flush-logs
        fi
        endscript
	su mysql mysql
}
END
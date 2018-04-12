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
#!/bin/bash
low_ram='262144' # 256MB
server_name='domain.com'
admin_port=2009
ssh_port=2010
# Random password for MySQL root account
root_password=`date |md5sum |cut -c '14-30'`
# Random password for MySQL admin account
admin_password=`date |md5sum |cut -c '14-30'`
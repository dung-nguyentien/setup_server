#!/usr/bin/env bash
chown -R nginx:nginx /var/lib/php
chown nginx:nginx /home/$server_name
chown -R nginx:nginx /home/*/public_html
chown -R nginx:nginx /home/*/private_html

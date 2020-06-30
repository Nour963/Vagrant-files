#!/bin/bash 
 #the user executing this script is not root, so sudo is needed
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y 
sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y 
sudo dnf makecache
sudo dnf module reset php
sudo dnf module enable php:remi-7.4 -y
sudo dnf install php php-opcache php-gd php-curl php-mysqlnd php-pdo -y 
sudo systemctl enable --now php-fpm 
sudo setsebool -P httpd_can_network_connect_db 1

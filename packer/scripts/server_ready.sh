#!/bin/bash
apt --version
apt -y update

apt-get -y install software-properties-common
add-apt-repository --yes ppa:ondrej/php
apt-get -y update

#server ready components
cat /etc/os-release 
echo "System Uptime Information"
uptime
hostname -f && hostnamectl 
apt-get -y install hwinfo && hwinfo –-short
lsblk && df –h
printenv

#Installation some basic things
apt-get -y install curl && curl ifconfig.me 
apt-get -y install net-tools

#let’s check the nginx is installed or not..
# dpkg -s  nginx  
# dpkg-query -l | grep nginx

# Nginx Information
apt  info nginx # this is used find the package if not installed
apt list --installed | grep nginx

#Other Service information
service --status-all | grep nginx
systemctl list-units --type=service --state=running

#Installation of LEMP
apt-get install nginx php7.3-fpm php7.3-cli php7.3-common php7.3-curl php7.3-mbstring php7.3-mysql php7.3-xml php7.3-dev php7.3-xml php7.3-bcmath php7.3-zip -y

#Installation of MYSQL

#wget https://repo.mysql.com/mysql-apt-config_0.8.15-1_all.deb
#dpkg -i mysql-apt-config_0.8.15-1_all.deb
apt install mysql-server php7.3-mysql -y
systemctl restart mysql
#mysql_secure_installation
systemctl enable mysql

apt-get install -y php7.3-redis
httpd -v
#Server version: Apache/2.4.33 ()
php -v
#PHP 7.2.5 (cli) (built: May 29 2018 19:08:12) ( NTS )
mysql --version
#mysql  Ver 15.1 Distrib 10.2.10-MariaDB,

MYSQL_ROOT=`sudo ./tmp/scripts/mysql_db_create.sh | grep 'Credential'`
# ARTIFACT=`packer build -machine-readable template-ubuntu-static.json | awk -F, '$0 ~/artifact,0,id/ {print $6}'`
# if [ -z "$ARTIFACT" ]; then exit 1; fi
# echo "packer output:"

chown -R $USER:www-data /var/www && chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \; 
find /var/www -type f -exec chmod 0664 {} \; 

#Log permission
chown -R $USER:www-data /var/log/nginx/
chown -R $USER:www-data /var/lib/php/sessions




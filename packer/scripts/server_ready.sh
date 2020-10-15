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


#Installation of LEMP
apt-get install nginx php7.3-fpm php7.3-cli php7.3-common php7.3-curl php7.3-mbstring php7.3-mysql php7.3-xml php7.3-dev php7.3-xml php7.3-bcmath php7.3-zip -y

nginx -v
#Server version: Apache/2.4.33 ()
php -v
#PHP 7.2.5 (cli) (built: May 29 2018 19:08:12) ( NTS )

################Database configuration#######################
# ARTIFACT=`packer build -machine-readable template-ubuntu-static.json | awk -F, '$0 ~/artifact,0,id/ {print $6}'`
# if [ -z "$ARTIFACT" ]; then exit 1; fi
# echo "packer output:"
apt -y install expect
MYSQL_PASS="mysupersecret"
apt-get -y install mysql-server
systemctl start mysql
systemctl enable mysql
mysql --version || { echo 'MySQL Service failed' ; exit 1; }

expect -f - <<-EOF
  set timeout 1
  spawn mysql_secure_installation
  expect "Press y|Y for Yes, any other key for No:"
  send -- "n\r"
  expect "New password:"
  send -- "${MYSQL_PASS}\r"
  expect "Re-enter new password:"
  send -- "${MYSQL_PASS}\r"
  expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
  send -- "y\r"
  expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
  send -- "y\r"
  expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
  send -- "y\r"
  expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
  send -- "y\r"
  expect eof
EOF

mysqladmin -u root -p$MYSQL_PASS ping

dbname=$(openssl rand -base64 12 | tr -dc A-Za-z | head -c 8 ; echo '')
dbuser=$(openssl rand -base64 12 | tr -dc A-Za-z | head -c 8 ; echo '')
dbpass=$(openssl rand -base64 8)

Q1="CREATE DATABASE IF NOT EXISTS $dbname;"
Q2="GRANT USAGE ON *.* TO $dbuser@localhost IDENTIFIED BY '$dbpass';"
Q3="GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost;"
Q4="FLUSH PRIVILEGES;"
Q5="SHOW DATABASES;"  
SQL="${Q1}${Q2}${Q3}${Q4}${Q5}"
mysql -uroot -p$MYSQL_PASS -e "$SQL" || { echo 'MySQL Service failed' ; exit 1; }

############################################################
chown -R $USER:www-data /var/www && chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \; 
find /var/www -type f -exec chmod 0664 {} \; 

#Log permission
chown -R $USER:www-data /var/log/nginx/
chown -R $USER:www-data /var/lib/php/sessions

systemctl status nginx 
systemctl status php7.3-fpm  
systemctl status mysql 


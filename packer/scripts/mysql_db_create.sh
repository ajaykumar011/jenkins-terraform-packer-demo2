#!/usr/bin/expect -f
# set your variables here

#we are automatically generating databasename and username from /dev/urandom command. 
dbname=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8 ; echo '');
dbuser=$(openssl rand -base64 12 | tr -dc A-Za-z | head -c 8 ; echo '')
dbpass=$(openssl rand -base64 8);
MYSQL_PASS=$(openssl rand -base64 12); #this is root password of mysql of 12 characters long.

#webroot="/var/www/html"
mysql --version
systemctl enable mysql 
systemctl restart mysql
apt-get -q -y install expect

expect -f - <<-EOF
  set timeout 1
  spawn mysql_secure_installation
  expect "Enter current password for root (enter for none):"
  send -- "\r"
  expect "Set root password?"
  send -- "y\r"
  expect "New password:"
  send -- "${MYSQL_PASS}\r"
  expect "Re-enter new password:"
  send -- "${MYSQL_PASS}\r"
  expect "Remove anonymous users?"
  send -- "y\r"
  expect "Disallow root login remotely?"
  send -- "y\r"
  expect "Remove test database and access to it?"
  send -- "y\r"
  expect "Reload privilege tables now?"
  send -- "y\r"
  expect eof
EOF

Q1="CREATE DATABASE IF NOT EXISTS $dbname;"
Q2="GRANT USAGE ON *.* TO $dbuser@localhost IDENTIFIED BY '$dbpass';"
Q3="GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost;"
Q4="FLUSH PRIVILEGES;"
Q5="SHOW DATABASES;"  
SQL="${Q1}${Q2}${Q3}${Q4}${Q5}"
  
mysql -uroot -p$MYSQL_PASS -e "$SQL"
echo Credentials,$MYSQL_PASS,$dbname,$dbuser,$dbpass

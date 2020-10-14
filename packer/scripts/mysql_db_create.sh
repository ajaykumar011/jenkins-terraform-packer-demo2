#!/usr/bin/expect -f
# set your variables here
apt-get -q -y install expect
MYSQL_PASS="SuperSecure"
#Installation of MYSQL

apt install mysql-server -y
systemctl start mysql
systemctl enable mysql
mysql --version || { echo 'MySQL Service failed' ; exit 1; }

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

mysqladmin -u root -p$MYSQL_PASS ping

Q1="CREATE DATABASE IF NOT EXISTS $dbname;"
Q2="GRANT USAGE ON *.* TO $dbuser@localhost IDENTIFIED BY '$dbpass';"
Q3="GRANT ALL PRIVILEGES ON $dbname.* TO $dbuser@localhost;"
Q4="FLUSH PRIVILEGES;"
Q5="SHOW DATABASES;"  
SQL="${Q1}${Q2}${Q3}${Q4}${Q5}"
mysql -uroot -p$MYSQL_PASS -e "$SQL" || { echo 'MySQL Service failed' ; exit 1; }

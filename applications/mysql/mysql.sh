#!/usr/bin/env bash

# Stop Script on Error
set -e

# For Debugging (print env. variables into a file)  
printenv > /var/log/colony-vars-"$(basename "$BASH_SOURCE" .sh)".txt
 

echo "****************************************************************"
echo "Updating System"
echo "****************************************************************"
apt-get update -y


echo "****************************************************************"
echo "Preparing MYSQL for silent installation"
echo "****************************************************************"
export DEBIAN_FRONTEND="noninteractive"
echo "mysql-server mysql-server/root_password password $DB_PASS" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DB_PASS" | debconf-set-selections


echo "****************************************************************"
echo "Installing MYSQL"
echo "****************************************************************"
apt-get install mysql-server -y
apt-get install mysql-client -y


echo "****************************************************************"
echo "Setting up local permission file"
echo "****************************************************************"
mkdir /home/pk;
bash -c "cat >> /home/pk/my.cnf" <<EOL
[client]
## for local server use localhost
host=localhost
user=$DB_USER
password=$DB_PASS
 
[mysql]
pager=/usr/bin/less
EOL

echo "****************************************************************"
echo "Creating database"
echo "****************************************************************"
mysql --defaults-extra-file=/home/pk/my.cnf << EOF
CREATE DATABASE ${DB_NAME};
EOF

echo "****************************************************************"
echo "Configuring Remote Connection Access"
echo "****************************************************************"
# updating sql config to not bind to a specific address
sed -i 's/bind-address/#bind-address/g' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql.service

# granting db access
mysql --defaults-extra-file=/home/pk/my.cnf << EOF
GRANT ALL ON *.* TO ${DB_USER}@'%' IDENTIFIED BY '${DB_PASS}';
EOF

mysql --defaults-extra-file=/home/pk/my.cnf -e "FLUSH PRIVILEGES;"

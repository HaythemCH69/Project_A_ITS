#!/bin/bash
JUSERNAME="admin"
JUSEREMAIL="admin@localhost.com"
JUSERPASS=""
DB="joomladb"
DBUSER="admin"
DBPASS="admin"

sudo yum -y update
sudo yum install httpd mariadb mariadb-server php php-mysql -y
sudo yum install nano unzip -y
sudo systemctl start mariadb

echo "CREATE DATABASE ${DB}" | mysql -u root --password=
echo "CREATE USER '${DBUSER}'@'localhost' IDENTIFIED BY '${DBPASS}';" | mysql -u root --password=
echo "GRANT ALL ON ${DB}.* TO '${DBUSER}'@'%';" | mysql -u root --password=
sed -i "s/#__/${DBPREFIX}/" installation/sql/mysql/joomla.sql
cat installation/sql/mysql/joomla.sql | mysql -u $DBUSER --password=$DBPASS $DB

sudo wget https://downloads.joomla.org/cms/joomla3/3-9-16/Joomla_3-9-16-Stable-Full_Package.zip
sudo unzip Joomla_3-9-16-Stable-Full_Package.zip -d /var/www/html
sudo chown -R apache:apache /var/www/html
sudo chmod 755 /var/www/html

sudo tee /etc/httpd/conf.d/joomla.conf <<- 'EOF'
<VirtualHost *:80>
     ServerAdmin admin@example.com
     DocumentRoot "/var/www/html"
     ServerName joomla.example.com
     ErrorLog "/var/log/httpd/example.com-error_log"
     CustomLog "/var/log/httpd/example.com-access_log" combined

<Directory "/var/www/html">
     DirectoryIndex index.html index.php
     Options FollowSymLinks
     AllowOverride All
     Require all granted
</Directory>
</VirtualHost>
EOF

sudo rm -f Joomla_3-9-16-Stable-Full_Package.zip
systemctl restart httpd

echo "For this Stack, you will use $(ip -f inet addr show enp0s8 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') IP Address"

echo "utiliser l'adresse IP pour afficher la Joomla page..."

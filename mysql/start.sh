echo "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" | mysql -u root
echo "GRANT ALL ON wordpress.* TO 'wordpress_user'@'%' IDENTIFIED BY 'password';" | mysql -u root
# % means all hosts
echo "FLUSH PRIVILEGES;" | mysql -u root

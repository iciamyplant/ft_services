FROM alpine:latest

EXPOSE 80 5000

RUN apk update ; apk add nginx ; apk add openrc

RUN openrc ; touch run/openrc/softlevel

COPY default.conf etc/nginx/conf.d/default.conf

RUN mkdir -p /usr/share/webapps/
RUN wget http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz ; tar zxvf phpMyAdmin-5.0.2-all-languages.tar.gz ; rm phpMyAdmin-5.0.2-all-languages.tar.gz ; mv phpMyAdmin-5.0.2-all-languages /usr/share/webapps/phpmyadmin
RUN ln -s /usr/share/webapps/phpmyadmin/ /var/www/localhost/htdocs/phpmyadmin
RUN mkdir -p /usr/share/webapps/phpmyadmin/tmp/ && chmod 777 /usr/share/webapps/phpmyadmin/tmp/

RUN apk add php7-fpm php7-mbstring php7-mcrypt php7-soap php7-openssl php7-gmp \
 php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype php7-common php7-session php7-iconv php7-json php7-gd php7-curl php7-xml php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom

COPY config.inc.php /usr/share/webapps/phpmyadmin
COPY start.sh ./

RUN apk add mariadb mariadb-common mariadb-client
RUN /etc/init.d/mariadb setup

#CMD service php-fpm7 start ; service nginx start ; sleep infinity
CMD service php-fpm7 start ; service mariadb start ; service nginx start ; sh ./start.sh ; sleep infinity

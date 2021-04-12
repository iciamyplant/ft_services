FROM alpine:latest

EXPOSE 80

RUN apk update ; apk add nginx ; apk add openrc

RUN openrc ; touch run/openrc/softlevel

COPY default.conf etc/nginx/conf.d/default.conf

RUN mkdir -p /usr/share/webapps/
RUN wget http://wordpress.org/latest.tar.gz ; tar -xzvf latest.tar.gz ; rm latest.tar.gz ; mv wordpress /usr/share/webapps/
RUN ln -s /usr/share/webapps/wordpress/ /var/www/localhost/htdocs/wordpress

#RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl
RUN apk add php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp \
 php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype
COPY wp-config.php /var/www/localhost/htdocs/wordpress

RUN apk add mariadb mariadb-common mariadb-client
RUN /etc/init.d/mariadb setup
COPY start.sh ./ 

CMD service php-fpm7 start ; service mariadb start ; service nginx start ; sh ./start.sh ; sleep infinity

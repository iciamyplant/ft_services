FROM alpine:latest

EXPOSE 3306

RUN apk update ; apk add telegraf ; apk add openrc

RUN openrc ; touch run/openrc/softlevel

RUN mkdir -p run/mysqld/
RUN mkdir -p /etc/telegraf/
RUN apk add mariadb mariadb-common mariadb-client
COPY start.sh ./
COPY telegraf.conf /etc/telegraf/

RUN echo -e "\n[mysqld]\nskip-networking=0\nskip-bind-address\n" >> /etc/my.cnf

CMD /etc/init.d/mariadb setup ; service mariadb start ; sh ./start.sh ; service telegraf start ; sleep infinity
#CMD sleep infinity

FROM alpine:latest

EXPOSE 3306

RUN apk update ; apk add openrc

RUN openrc ; touch run/openrc/softlevel

RUN apk add mariadb mariadb-common mariadb-client
RUN /etc/init.d/mariadb setup
COPY start.sh ./

RUN echo -e "\n[mysqld]\nskip-networking=0\nskip-bind-address\n" >> /etc/my.cnf

CMD service mariadb start ; sh ./start.sh ; sleep infinity                                                                                                                 

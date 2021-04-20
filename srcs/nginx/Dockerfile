FROM alpine:latest

EXPOSE 80 443

RUN apk update ; apk add telegraf ; apk add nginx ; apk add openrc

RUN openrc ; touch run/openrc/softlevel

RUN mkdir -p /etc/telegraf/
COPY start.sh ./
COPY telegraf.conf /etc/telegraf/
COPY default.conf etc/nginx/conf.d/default.conf
COPY index.html /var/www/localhost/htdocs

RUN apk add openssl
RUN mkdir /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=FR/ST=France/L=Paris/O=42/OU=42/CN=localhost" -keyout /etc/nginx/ssl/example.key -out /etc/nginx/ssl/example.crt

#RUN echo "daemon off;" >> etc/nginx/conf.d/default.conf
RUN mkdir -p /run/nginx
CMD service telegraf start ; sh ./start.sh 
#nginx -g 'daemon off;'

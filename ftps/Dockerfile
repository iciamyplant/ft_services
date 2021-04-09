FROM alpine:latest

EXPOSE 20 21 21009-21011

RUN apk update ; apk add vsftpd ; apk add openrc

RUN openrc ; touch run/openrc/softlevel

COPY vsftpd.conf etc/vsftpd/vsftpd.conf

RUN adduser -D ftpuser ; echo "ftpuser:password"  | chpasswd

RUN apk add openssl ; openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=FR/ST=France/L=Paris/O=42/OU=42/CN=localhost" -keyout /etc/ssl/private/example.key -out /etc/ssl/private/example.crt

CMD service vsftpd start ; sleep infinity

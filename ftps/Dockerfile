FROM alpine:latest

EXPOSE 21

RUN apk update ; apk add vsftpd ; apk add openrc

RUN openrc ; touch run/openrc/softlevel

CMD sleep infinity

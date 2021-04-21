FROM alpine:latest

EXPOSE 8086

RUN apk update ; apk add telegraf ; apk add influxdb ; apk add openrc ; openrc ; touch run/openrc/softlevel

COPY telegraf.conf /etc/
COPY start.sh ./

CMD service telegraf start ; sleep 5 ; sh ./start.sh

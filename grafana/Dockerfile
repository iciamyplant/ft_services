FROM alpine:latest

EXPOSE 3000 8086

RUN apk update ; apk add telegraf ; apk add influxdb ; apk add openrc ; openrc ; touch run/openrc/softlevel

RUN sleep 10

COPY telegraf.conf /etc/
COPY start.sh ./

CMD service influxdb start ; service telegraf start ; sleep 5 ; sh ./start.sh ; sleep infinity

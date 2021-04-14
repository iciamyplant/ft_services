FROM alpine:latest

EXPOSE 3000 8086


RUN wget https://dl.grafana.com/enterprise/release/grafana-enterprise-7.5.3.linux-amd64.tar.gz ; tar -zxvf grafana-enterprise-7.5.3.linux-amd64.tar.gz ; rm grafana-enterprise-7.5.3.linux-amd64.tar.gz

RUN apk update ; apk add telegraf ; apk add influxdb ; apk add libc6-compat ; apk add openrc ; openrc ; touch run/openrc/softlevel

RUN sleep 10

COPY telegraf.conf /etc/
COPY start.sh ./

CMD service influxdb start ; service telegraf start ; sleep 5 ; sh ./start.sh ; sleep infinity

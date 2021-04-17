FROM alpine:latest

EXPOSE 3000

RUN wget https://dl.grafana.com/enterprise/release/grafana-enterprise-7.5.3.linux-amd64.tar.gz ; tar -zxvf grafana-enterprise-7.5.3.linux-amd64.tar.gz ; rm grafana-enterprise-7.5.3.linux-amd64.tar.gz

RUN apk update ; apk add telegraf ; apk add influxdb ; apk add libc6-compat ; apk add openrc ; openrc ; touch run/openrc/softlevel

COPY telegraf.conf /etc/
COPY ./datasource/default.yaml /grafana-7.5.3/conf/provisioning/datasources
COPY ./provider/default.yaml /grafana-7.5.3/conf/provisioning/dashboards
COPY ./dashboards/grafana.json /grafana-7.5.3/conf/provisioning/dashboards
COPY ./dashboards/influxdb.json /grafana-7.5.3/conf/provisioning/dashboards
COPY ./dashboards/nginx.json /grafana-7.5.3/conf/provisioning/dashboards
COPY ./dashboards/ftps.json /grafana-7.5.3/conf/provisioning/dashboards
COPY ./dashboards/wordpress.json /grafana-7.5.3/conf/provisioning/dashboards
COPY ./dashboards/phpmyadmin.json /grafana-7.5.3/conf/provisioning/dashboards
COPY ./dashboards/mysql.json /grafana-7.5.3/conf/provisioning/dashboards
COPY start.sh ./

CMD service influxdb start ; service telegraf start ; sleep 5 ; sh ./start.sh ; sleep infinity

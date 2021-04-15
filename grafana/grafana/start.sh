#DOCKERID=$(head -1 /proc/self/cgroup|cut -d/ -f3 |cut -c1-12)
#sed "s/74b98dc7afc7/$DOCKERID/g" -i /grafana-7.5.3/conf/provisioning/dashboards/grafana.json
#sed "s/74b98dc7afc7/$DOCKERID/g" -i /grafana-7.5.3/conf/provisioning/dashboards/influxdb.json

sed "s/74b98dc7afc7/$HOSTNAME/g" -i /grafana-7.5.3/conf/provisioning/dashboards/grafana.json
sed "s/74b98dc7afc7/$HOSTNAME/g" -i /grafana-7.5.3/conf/provisioning/dashboards/influxdb.json
cd ./grafana-7.5.3/bin/ && ./grafana-server

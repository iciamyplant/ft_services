echo "create database telegraf" | influx
echo "create user telegrafuser with password 'password'" | influx
echo "grant ALL on telegraf to telegrafuser" | influx

DOCKERID=$(head -1 /proc/self/cgroup|cut -d/ -f3 |cut -c1-12)
sed "s/74b98dc7afc7/$DOCKERID/g" -i /grafana-7.5.3/conf/provisioning/dashboards/grafana.json

cd ./grafana-7.5.3/bin/ && ./grafana-server

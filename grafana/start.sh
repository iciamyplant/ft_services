echo "create database telegraf" | influx
echo "create user telegrafuser with password 'password'" | influx
echo "grant ALL on telegraf to telegrafuser" | influx
cd ./grafana-7.5.3/bin/ && ./grafana-server

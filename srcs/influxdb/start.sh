service influxdb start
sleep 5
echo "create database telegraf" | influx
echo "create user telegrafuser with password 'password'" | influx
echo "grant ALL on telegraf to telegrafuser" | influx
sleep infinity

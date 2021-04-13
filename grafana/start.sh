echo "create database telegraf" | influx
echo "create user telegraf with password 'password'" | influx
echo "grant ALL on telegraf to telegraf" | influx

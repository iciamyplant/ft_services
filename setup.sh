#!/bin/bash

#sudo usermod -aG docker user42 ; newgrp docker
minikube start --vm-driver=docker
eval $(minikube docker-env)

docker build -t my_nginx srcs/nginx/.
docker build -t my_ftps srcs/ftps/.
docker build -t my_influxdb srcs/influxdb/.
docker build -t my_grafana srcs/grafana/.
docker build -t my_mysql srcs/mysql/.
docker build -t my_wordpress srcs/wordpress/.
docker build -t my_phpmyadmin srcs/phpmyadmin/.

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

sleep 5

minikube addons enable dashboard
kubectl apply -f srcs/metallb/metallb-deployment.yaml
kubectl apply -f srcs/nginx/nginx-deployment.yaml
kubectl apply -f srcs/nginx/nginx-service.yaml
kubectl apply -f srcs/influxdb/influxdb-deployment.yaml
kubectl apply -f srcs/influxdb/influxdb-volume.yaml
kubectl apply -f srcs/influxdb/influxdb-service.yaml
kubectl apply -f srcs/grafana/grafana-deployment.yaml
kubectl apply -f srcs/grafana/grafana-service.yaml
kubectl apply -f srcs/ftps/ftps-deployment.yaml
kubectl apply -f srcs/ftps/ftps-service.yaml
kubectl apply -f srcs/mysql/mysql-deployment.yaml
kubectl apply -f srcs/mysql/mysql-volume.yaml
kubectl apply -f srcs/mysql/mysql-service.yaml
kubectl apply -f srcs/wordpress/wordpress-deployment.yaml
kubectl apply -f srcs/wordpress/wordpress-service.yaml
kubectl apply -f srcs/phpmyadmin/phpmyadmin-deployment.yaml
kubectl apply -f srcs/phpmyadmin/phpmyadmin-service.yaml

#minikube dashboard

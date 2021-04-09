#!/bin/bash

kubectl delete deployments --all ; kubectl delete services --all ; kubectl delete pods --all
#minikube restart
minikube stop ; minikube delete
minikube start --vm-driver=docker
eval $(minikube docker-env)

docker build -t my_nginx nginx/.
docker build -t my_ftps ftps/.

#install metallb
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

sleep 5

minikube addons enable dashboard
kubectl apply -f metallb-deployment.yaml
kubectl apply -f nginx/nginx-deployment.yaml
kubectl apply -f nginx/nginx-service.yaml
kubectl apply -f ftps/ftps-deployment.yaml
kubectl apply -f ftps/ftps-service.yaml

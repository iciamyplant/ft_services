#!/bin/bash

#minikube restart
minikube stop ; minikube delete
minikube start --vm-driver=docker
eval $(minikube docker-env)

#build images
docker build -t my_nginx srcs/nginx/.

#install metallb
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

sleep 5

minikube addons enable dashboard
kubectl apply -f srcs/metallb/metallb-deployment.yaml
kubectl apply -f srcs/nginx/nginx-deployment.yaml
kubectl apply -f nginx-service.yaml

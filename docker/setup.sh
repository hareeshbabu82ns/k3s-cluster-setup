#!/bin/sh

echo "----------------------------------------Cleaning Up"
docker-compose -f k3s-docker.yaml down
sudo rm -rf deploy/

echo "----------------------------------------Installing Cluster"
docker-compose -f k3s-docker.yaml up -d --scale node=2
sleep 10

echo "----------------------------------------Copying kubeconfig"
cp ./deploy/out/kubeconfig.yaml $HOME/.kube/k3s-docker.yaml
export KUBECONFIG=$HOME/.kube/k3s-docker.yaml
kubectl config use-context default

echo "----------------------------------------"
kubectl get all -A

echo "----------------------------------------Installing Helms"
helm install -f traefik-helm-values.yaml \
   traefik traefik/traefik -n kube-system
helm install nginx t3n/nginx
helm install heimdall k8s-at-home/heimdall
sleep 5

echo "----------------------------------------External IP"
kubectl get service traefik -n kube-system -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'

echo "----------------------------------------Applying Ingress"
kubectl apply -f nginx-ingress.yaml
sleep 2
kubectl apply -f heimdall-ingress.yaml
sleep 2
kubectl apply -f k8s-dashboard-ingress.yaml
sleep 2
kubectl apply -f traefik-dash-ingress.yaml
sleep 2

echo "----------------------------------------"
kubectl get nodes -o wide

echo "----------------------------------------"
kubectl get all -A

echo "----------------------------------------"
kubectl get ingress -A

echo "----------------------------------------"
kubectl get endpoints

echo "----------------------------------------End"
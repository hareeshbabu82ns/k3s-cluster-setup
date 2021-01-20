## Install Cluster

* [V3 Docker Compose Ref](https://rancher.com/docs/k3s/latest/en/advanced/#using-docker-as-the-container-runtime)

* use docker-compose to stand up a cluster
```sh
$> docker-compose -f k3s-docker.yaml up -d

# see nodes
$> docker ps

# stop cluster
$> docker-compose -f k3s-docker.yaml down
```

* copy kubeconfig to work from local system
```sh
$> cp ./deploy/out/kubeconfig.yaml ~/.kube/k3s-docker.yaml
```
__Note:__ update context and user details if needed

* switch to new context
```sh
$> kubectl config use-context default
```
__Note:__ set config file path if needed
```sh
$> export KUBECONFIG=~/.kube/k3s-docker.yaml;other.yaml
```

* install load balencer using `helm`
```sh
$> helm repo add traefik https://helm.traefik.io/traefik
$> helm repo update
$> helm install traefik traefik/traefik -n kube-system
```

* install kubernetes dashboard
```sh
$> kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
```

* expose dashoard as ingress
```sh
$> kubectl apply -f k8s-dashboard-ingress.yaml

$> curl --head -H "Host: dash.kube.uat.io" localhost
```
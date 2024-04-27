---
title: 'Kubernetes, Nginx Ingress and Istio Workshop'
date: '2018-11-07'
published: true
slideshow: true
categories: [ containers ]
search:
  keywords: ['docker', 'kubernetes', 'containers', 'istio', 'ingress']
---

## Setup

Prerequisites: [Virtualbox](https://www.virtualbox.org/wiki/Downloads)

macOS instructions:

```bash
brew update
brew install kubernetes-cli kubernetes-helm kubectx stern
brew upgrade kubernetes-cli kubernetes-helm kubectx stern
brew cask install minikube
brew cask upgrade minikube
```

Append to your `.bashrc`:

```bash
. "/usr/local/etc/profile.d/bash_completion.sh"
```

---

## Ubuntu/Debian Setup

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.30.0/minikube-linux-amd64 && chmod +x minikube && sudo cp minikube /usr/local/bin/ && rm minikube
```

---

## Centos/RHEL/Fedora Setup

```bash
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubectl

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.30.0/minikube-linux-amd64 && chmod +x minikube && sudo cp minikube /usr/local/bin/ && rm minikube
```

---

## Windows Setup

Use the [Chocolaty](https://chocolatey.org/) package manager:

```bash
choco install kubernetes-cli kubernetes-helm
```

https://github.com/kubernetes/minikube/releases

Download the minikube-windows-amd64.exe file,
rename it to minikube.exe and add it to your path.

---

## Cluster Creation

:warning: This will delete your current Minikube setup.

```bash
minikube delete
minikube start --memory=8192 --cpus=4
kubectl get --all-namespaces deploy
kubectl get --all-namespaces pod -w
```

Open Kubernetes dashboard:

```bash
kubectl proxy
open http://localhost:8001/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy
```

---

## Metrics Server

Kubernetes doesn't have built-in metrics:

```bash
kubectl top nodes
```

Install the official metrics server:

```bash
cd /tmp
git clone -b v0.2.1 --single-branch --depth 1 https://github.com/kubernetes-incubator/metrics-server.git
cd metrics-server
kubectl create -f deploy/
kubectl top nodes
```

---

## Troubleshooting

```bash
kubectl logs -n kube-system -f deploy/metrics-server
open https://github.com/kubernetes-incubator/metrics-server/search?q=error+forbidden

minikube stop
minikube start --memory=8192 --cpus=4 --extra-config=kubelet.authentication-token-webhook=true
kubectl top nodes
```

---

## Helm

Install Helm's server component:

```bash
helm version
helm init --debug --dry-run
helm init
helm version
kubectl get -n kube-system pods | grep tiller
```

---

## Install a Helm Chart

https://github.com/helm/charts/tree/master/stable/ghost#configuration

```bash
helm install stable/ghost --name ghost --set serviceType=NodePort,ghostUsername=admin,ghostPassword=password123,mariadb.db.password=testghost,ghostHost=dev.ghost.local
helm ls
```

Examine new objects via API:

```bash
kubectl proxy
open http://localhost:8001/api/v1
open http://localhost:8001/api/v1/namespaces
open http://localhost:8001/api/v1/namespaces/default/services
open http://localhost:8001/api/v1/namespaces/default/services/ghost
open http://localhost:8001/api/v1/namespaces/default/services/http:ghost:80/proxy
open http://localhost:8001/api/v1/namespaces/default/services/http:ghost:80/proxy/ghost
```

---

## Ingress

Handle external traffic

* Service IP
* Node IP
* Service Port

Access NodePort service directly:

```bash
kubectl get svc
minikube ip
kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services ghost

open http://`minikube ip`:`kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services ghost`
```

---

## Ingress Services

* (Cloud) Load-balancer?
* NGINX
* Istio
* Traefik
* HAProxy
* And more...

---

## NGINX Ingress

https://kubernetes.github.io/ingress-nginx/

Use Helm to install NGINX ingress

```bash
helm install stable/nginx-ingress --name my-nginx --set rbac.create=true,controller.service.type=NodePort,controller.service.nodePorts.http=31380
```

Inspect:

```bash
kubectl get pod,svc
curl -v http://`minikube ip`:`kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services my-nginx-nginx-ingress-controller`
```

---

## Ingress Object

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: blog
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: ghost
          servicePort: 80
        path: /blog
```

---

## Ingress Object Deploy

```bash
cat <<'EOF' | kubectl create -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: blog
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: ghost
          servicePort: 80
        path: /blog
EOF
```

---

## Ingress Test

```bash
curl -v http://`minikube ip`:31380/blog
```

```bash
kubectl edit cm my-nginx-nginx-ingress-controller

## Add this to data:
ssl-redirect: "false"
```

Re-deploy Ghost: Disable NodePort, add ghostPath

```bash
helm delete --purge ghost
kubectl delete pvc --all
helm install stable/ghost --name ghost --set serviceType=ClusterIP,ghostUsername=admin,ghostPassword=password123,mariadb.db.password=testghost,ghostHost=dev.ghost.local,ghostPath=/blog

kubectl get pod -w

open http://`minikube ip`:31380/blog
open http://`minikube ip`:31380/blog/ghost
```

---

## Managing Helm Deployments

Let's get rid of the NGINX ingress:

```bash
helm ls
helm history my-nginx
helm delete my-nginx
helm delete --purge my-nginx

kubectl delete ingress blog
```

---

## Istio

```bash
cd /tmp
git clone https://github.com/istio/istio.git
cd istio

kubectl apply -f install/kubernetes/helm/istio/templates/crds.yaml
helm install install/kubernetes/helm/istio --name istio --namespace istio-system --set global.proxy.includeIPRanges="10.0.0.1/24",global.crds=false,grafana.enabled=true,servicegraph.enabled=true,tracing.enabled=true,kiali.enabled=true,mixer.istio-policy.autoscaleEnabled=false,mixer.istio-telemetry.autoscaleEnabled=false

kubectl get pod -n istio-system -w
kubectl top nodes
```

---

## Istio Gateway

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: common
spec:
  selector:
    istio: ingressgateway  # use istio default controller
  servers:
  - hosts:
    - "*"
    port:
      number: 80
      name: http
      protocol: HTTP
```

---

## Istio Gateway Deploy

```bash
cat <<'EOF' | kubectl create -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: common
spec:
  selector:
    istio: ingressgateway  # use istio default controller
  servers:
  - hosts:
    - "*"
    port:
      number: 80
      name: http
      protocol: HTTP
EOF
```

---

## Istio VirtualService

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: common
spec:
  hosts:
  - "*"
  gateways:
  - common
  http:
  - match:
    - uri:
        prefix: /blog
    route:
    - destination:
        host: ghost.default.svc.cluster.local
        port:
          number: 80
```

---

## Istio VirtualService Deploy

```bash
cat <<'EOF' | kubectl create -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: common
spec:
  hosts:
  - "*"
  gateways:
  - common
  http:
  - match:
    - uri:
        prefix: /blog
    route:
    - destination:
        host: ghost.default.svc.cluster.local
        port:
          number: 80
EOF
```

---

## Istio Sidecar

Istio automatically injects sidecars to pods:

```bash
kubectl label namespace default istio-injection=enabled
kubectl delete pod -l app=ghost
kubectl get pod -w
kubectl logs -f deploy/ghost -c ghost

kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}'

open http://`minikube ip`:31380/blog
open http://`minikube ip`:31380/blog/author/ghost

kubectl logs -f --tail 100 -n istio-system deploy/istio-ingressgateway
kubectl logs -f --tail 100 -n istio-system deploy/istio-pilot -c discovery
```

---

## Istio Add-ons

Open Kiali:

```bash
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=kiali -o jsonpath='{.items[0].metadata.name}') 20001:20001

open http://localhost:20001
## admin / admin
```

Open tracer (Jaeger):

```bash
kubectl port-forward -n istio-system $(kubectl get pod -n istio-system -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 16686:16686

open http://localhost:16686
```

Generate service graph:

```bash
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}') 8088:8088

open http://localhost:8088/force/forcegraph.html
```

---

## Grafana

```bash
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000

open http://localhost:3000/dashboard/db/istio-mesh-dashboard
```

---

## kubectl Cheat-sheet

```bash
kubectl get namespaces
kubectl get deploy
kubectl get -n ingress-nginx deploy
kubectl get -n kube-system deploy
kubectl get --all-namespaces deploy
kubectl get pods -w
kubectl get pods -o wide
kubectl get events

kubectl create -f foobar.yml
kubectl explain services
kubectl get pods,svc,deploy
kubectl describe deploy push-service
kubectl delete deploy push-service
kubectl cluster-info
kubectl api-resources
kubectl top node
kubectl top pods
kubectl logs -f deploy/ghost
kubectl logs -f deploy/ghost -c ghost
kubectl logs --previous ghost-97d8bf485-p25r2
kubectl exec -it ghost-97d8bf485-p25r2 -- tail /var/log/apt/history.log
```

---

## Admire Your Work

```bash
kubectl get all --all-namespaces
```

<br />
Thanks!
<br />
<br />

---

## Related Articles

* [Docker & Kubernetes 101](./docker-and-kubernetes-101)
* [Developing with Docker containers](./develop-with-containers)

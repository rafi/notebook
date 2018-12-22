# Kubernetes (K8S) 101

https://docs.google.com/presentation/d/1BhUfwkiRTQZsvN9kCpxpbT09kpWFTiuAprOfGemrf6Q

---

## Workstation Setup

```bash
brew install kubernetes-cli kubectx \
  fzf stern bash-completion@2 --with-short-names
```

Append to your `~/.bash_profile` for awesome shell completion:

```bash
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
  . /usr/local/share/bash-completion/bash_completion
fi
```

---

## Setup kubectl Context

_Cluster_ + _User_ = *Context*

```bash
# Integration
kubectl config set-cluster foobar-int-developer --server=https://1.2.3.4:6443 --certificate-authority=$HOME/.kube/int/ca.pem
kubectl config set-credentials int-developer --client-certificate=$HOME/.kube/int/developer.crt --client-key=$HOME/.kube/int/developer.key
kubectl config set-context foobar-int-developer --cluster=foobar-int-developer --user=int-developer

# Staging
kubectl config set-cluster foobar-stg-developer --server=https://5.6.7.8:6443 --certificate-authority=$HOME/.kube/stg/ca.pem
kubectl config set-credentials stg-developer --client-certificate=$HOME/.kube/stg/developer.crt --client-key=$HOME/.kube/stg/developer.key
kubectl config set-context foobar-stg-developer --cluster=foobar-stg-developer --user=stg-developer
```

---

## kctx

```bash
kubectl config use-context foobar-int-developer
kctx
kctx foobar-int-developer
kctx foobar-stg-developer
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

kubectl get pods,svc,deploy
kubectl describe deploy push-service
kubectl top node
kubectl top pods
kubectl logs -f deploy/trips
kubectl logs -f deploy/trips -c trips
kubectl logs --previous trips-7d7f649996-nz876
kubectl exec -it trips-6c6887547d-lhbsb -- tail -f /var/log/myapp/api.log
```

---

## Examining Deployed Objects

```bash
kubectl get deploy
kubectl get pod
kubectl get svc
kubectl get deploy,pod,svc | grep myapp
kubectl get all | grep myapp
```

---

## Describe Deployment

```bash
kubectl describe deploy myapp
kubectl describe pod myapp-649887b547-fh7vw
kubectl top pod | grep myapp
```

---

## Analyze Logs

```bash
kubectl logs -f myapp-649887b547-fh7vw
kubectl exec -it myapp-649887b547-fh7vw -- tail -f /var/log/myapp/api.log
```

---

## Jump into Container

```bash
$ kubectl exec -it myapp-649887b547-fh7vw sh
> top
> free -h
> exit
```

---

![Mind blown.](./img/mindblown.png)

---

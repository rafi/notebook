---
title: Kubernetes Upgrade Notes
date: '2018-11-07'
category: containers
tags:
- kubernetes
search:
  keywords: ['docker', 'kubernetes', 'containers', 'istio', 'ingress']
---
# Kubernetes Upgrade Notes

## Prerequisite

1. Upgrade to the latest minor release. e.g. you are using 1.9.3, upgrade to
   latest 1.9.x
2. Read the [CHANGELOG] of the target version. Watch out for sections:
  * Action Required
  * Deprecations and Removals
3. Consider etcd backup.

## Upgrade

- etcd per recommended & supported version.
- CNI and/or CoreDNS? Drain node-by-node.
- kubectl
- control nodes kubernetes binaries e.g. kube-apiserver,
  kube-controller-manager, kube-scheduler, etc.
- worker nodes e.g. kubelet, kube-proxy, CNI, etc.

## 1.14 -> 1.15 Case-study

For target version [CHANGELOG], the minimal MUST read:

- [Known Issues](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.15.md#known-issues)
- [Urgent Upgrade Notes](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.15.md#urgent-upgrade-notes)
- [Deprecations and Removals](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.15.md#deprecations-and-removals)

There's also searchable release notes: https://relnotes.k8s.io/?releaseVersions=1.15.0

Deprecated API versions in 1.15:

- **Ingress**: migrate to `networking.k8s.io/v1beta1`
- **NetworkPolicy**: migrate to `networking.k8s.io/v1`
- **PodSecurityPolicy**: migrate to `policy/v1beta1`
- **DaemonSet**: migrate to `apps/v1`
- **Deployment**: migrate to `apps/v1`
- **ReplicaSet**: migrate to `apps/v1`
- **PriorityClass**: migrate to `scheduling.k8s.io/v1`

Check currently used objects:

```sh
kubectl get ingresses.extensions -A
kubectl get ingress.networking.k8s.io -A

kubectl get networkpolicies.extensions -A
kubectl get networkpolicies.networking.k8s.io -A

kubectl get podsecuritypolicies.extensions -A
kubectl get podsecuritypolicies.policy -A

kubectl get daemonsets.extensions -A
kubectl get daemonsets.apps -A

kubectl get deployment.extensions -A
kubectl get deployment.apps -A

kubectl get replicasets.extensions -A
kubectl get replicasets.apps -A

kubectl get priorityclasses.scheduling.k8s.io -A
```

## Cluster List

DigitalOcean has a CLI tool, [clusterlint] and a knowledge-base for common
issues & fixes:
https://www.digitalocean.com/docs/kubernetes/resources/clusterlint-errors/

## Resources

- https://www.tauceti.blog/post/kubernetes-the-not-so-hard-way-with-ansible-upgrading-kubernetes/
- https://www.tauceti.blog/post/kubernetes-upgrade-nodes-1.14-1.15/

[CHANGELOG]: https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG
[clusterlint]: https://github.com/digitalocean/clusterlint

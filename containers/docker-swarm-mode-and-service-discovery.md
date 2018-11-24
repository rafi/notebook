---
title: Docker Swarm Mode and Service Discovery
path: containers/docker-swarm-mode-and-service-discovery
date: 2017-11-25
updated:
description:
categories:
tags: [ docker, swarm, prometheus, service disconvery ]
---
# Docker Swarm Mode, Prometheus and Service Discovery

## 3rd-Party

| Name | Description | Language | URL |
| ---- | ----------- | -------- | --- |
| castlemilk / prom_dns_sd | Bridge DNS service discovery and file_sd in an more automated fashion | Python | [github](https://github.com/castlemilk/prom_dns_sd) |
| ContainerSolutions / prometheus-swarm-discovery | This is a POC for Prometheus service discovery on Docker Swarm | Go | [github](https://github.com/ContainerSolutions/prometheus-swarm-discovery) |
| DistributedSystemsGroup / swarm-dns | Simple daemon to keep a Bind DNS server in sync with containers created in Docker Swarm | Go | [github](https://github.com/DistributedSystemsGroup/swarm-dns)
| function61 / prometheus-docker-swarm | Bridges Docker Swarm services to Prometheus via file-based service discovery | Go | [github](https://github.com/function61/prometheus-docker-swarm)
| jamesmcdonald / prometheus-swarmer | Service discovery to generate Prometheus configuration for services on Docker Swarm | Python | [github](https://github.com/jamesmcdonald/prometheus-swarmer) |
| msiebuhr / prometheus-mdns-sd | mDNS/ZeroConf/Bonjour service discovery for Prometheus | Go | [github](https://github.com/msiebuhr/prometheus-mdns-sd) |
| RobustPerception / PushProx | Proxy to allow Prometheus to scrape through NAT etc. | Go | [github](https://github.com/RobustPerception/PushProx) |
| rayhou / prometheus-file-sd | Parse your docker cloud containers and write a json file for prometheus service discovery | Shell | [github](https://github.com/rayhou/prometheus-file-sd) |
| tomverelst / prommer | Service discovery for Prometheus using Docker | Go | [github](https://github.com/tomverelst/prommer) |
| wanglf / prometheus-service-discovery | Auto discover monitoring nodes such as prometheus node exporter, haproxy exporter, mysqld exporter etc. | Java | [github](https://github.com/wanglf/prometheus-service-discovery) |
| wu8685 / prometheus-swarm-sd | Service discovery plugin for Swarm | Go | [github](https://github.com/wu8685/prometheus-swarm-sd) |

## Orchestration Samples

| Name | Description | URL |
| ---- | ----------- | --- |
| stefanprodan / swarmprom | Instrumentation with Prometheus, Grafana, cAdvisor, Node Exporter and Alert Manage | [github](https://github.com/stefanprodan/swarmprom/)
| bvis / docker-prometheus-swarm | Sample Prometheus that can be used as a sample to get Swarm cluster metrics | [github](https://github.com/bvis/docker-prometheus-swarm)
| chmod666org / docker-swarm-prometheus | Docker stack to deploy prometheus monitoring on a Docker Swarm Cluster | [github](https://github.com/chmod666org/docker-swarm-prometheus) |
| Official Docker | Collect Docker metrics with Prometheus | [docs.docker.com](https://docs.docker.com/engine/admin/prometheus/) |

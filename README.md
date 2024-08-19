# PhotoAtom Bootstrap Self Hosted Kubernetes Cluster

This repository mainly handles scripts for automation of setting up and destroying kubernetes cluster for usage of development of PhotoAtom. It utilized JSON based configuration to start and delete clusters.

---

## Requirements

The list of requirements for utilizing this repository is:

- [Docker](https://www.docker.com/) - Prerequisite to Minikube as our primary driver.
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) - our clusters will be utilizing Minikube in the background to bring up and tear down Kubernetes clusters.
- [JQ](https://github.com/jqlang/jq) - Simple JSON processing.

## Usage

1. Edit the [configuration](./config.json) as per your convenience, an example for the same can be found here:

```json
{
  "cluster_name": "NAME OF THE CLUSTER",
  "cluster_configuration": {
    "vcpu_per_node": NUMBER OF vCPUs TO BE DEDICATED PER NODE,
    "ram_per_node": RAM TO BE DEDICATED PER NODE,
    "nodes": NUMBER OF NODES,
    "driver": "DRIVER OF CHOICE"
  },
  "plugins": ["PLUGINS TO BE ENABLED"]
}
```

2. To spin up the cluster, execute the following commands in your terminal:

```
chmod +x ./scripts/up.sh
./scripts/up.sh config.json
```

2. To tear down the cluster, execute the following commands in your terminal:

```
chmod +x ./scripts/down.sh
./scripts/down.sh config.json
```


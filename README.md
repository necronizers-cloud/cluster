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
    "vcpu_per_node": "NUMBER OF vCPUs TO BE DEDICATED PER NODE",
    "ram_per_node": "RAM TO BE DEDICATED PER NODE",
    "nodes": "NUMBER OF NODES",
    "driver": "DRIVER OF CHOICE"
  },
  "plugins": ["PLUGINS TO BE ENABLED"],
  "operators": [
    {
      "name": "Operator Name",
      "steps": ["STEPS HERE"]
    }
  ]
}
```

For operator automation, refer to [Operator Installation Automation](#operator-installation-automation) guide

1. To spin up the cluster, execute the following commands in your terminal:

```
chmod +x ./scripts/up.sh
./scripts/up.sh config.json
```

2. To tear down the cluster, execute the following commands in your terminal:

```
chmod +x ./scripts/down.sh
./scripts/down.sh config.json
```

## Operator Installation Automation

The structure to use for Operator Installation is given below:

```json
{
  "name": "Operator Name",
  "steps": ["STEPS HERE"]
}
```

`name` can be any name you want to use and `steps` are all commands required for installing the Operator/CRDs. These are comma seperated strings in an array which are executed one at a time.

For example, MinIO's automation looks like this:

```json
{
  "name": "MinIO",
  "steps": ["kubectl apply -k \"github.com/minio/operator?ref=v6.0.2\""]
}
```


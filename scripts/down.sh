#!/bin/bash

CONFIG_JSON_PATH=$1

# --------------------------------- SCRIPT START --------------------------------- #

CLUSTER_NAME=$(jq -rc '.cluster_name' "$CONFIG_JSON_PATH")

CHECK_CLUSTER_EXISTENCE=$(minikube profile list | grep -c "$CLUSTER_NAME" || true)

if [[ "$CHECK_CLUSTER_EXISTENCE" != "0" ]]
then
  # Deletion of the cluster by name.
  minikube --profile "$CLUSTER_NAME" delete
fi
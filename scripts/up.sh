#!/bin/bash

CONFIG_JSON_PATH=$1

# Function to set up cluster with the provided configuration.
function set_up_cluster {
  CONFIG_JSON_PATH=$1

  echo "##################################"
  echo "##                              ##"
  echo "##      Setting Up Cluster      ##"
  echo "##                              ##"
  echo "##################################"

  # Extract cluster configuration.
  CLUSTER_NAME=$(jq -rc '.cluster_name' "$CONFIG_JSON_PATH")
  VCPU_PER_NODE=$(jq -rc '.cluster_configuration.vcpu_per_node' "$CONFIG_JSON_PATH")
  RAM_PER_NODE=$(jq -rc '.cluster_configuration.ram_per_node' "$CONFIG_JSON_PATH")
  NODES=$(jq -rc '.cluster_configuration.nodes' "$CONFIG_JSON_PATH")
  DRIVER=$(jq -rc '.cluster_configuration.driver' "$CONFIG_JSON_PATH")

  echo -e "\n\n\n\n# --------------- CLUSTER CONFIGURATION --------------- #\n\n"
  echo "Name: $CLUSTER_NAME"
  echo "vCPUs Per Node: $VCPU_PER_NODE"
  echo "RAM Per Node: $RAM_PER_NODE"
  echo "Number of Nodes: $NODES"
  echo "Driver Selected: $DRIVER"

  echo "Setting up cluster $CLUSTER_NAME ..."

  # Setup cluster using minikube.
  minikube --profile "$CLUSTER_NAME" start --cpus "$VCPU_PER_NODE" --memory "$RAM_PER_NODE"GB --nodes "$NODES" --driver "$DRIVER"

  if [[ $? != 0 ]]
  then
    echo "##################################"
    echo "##                              ##"
    echo "##  Setting Up Cluster Failed   ##"
    echo "## Please check the above logs! ##"
    echo "##                              ##"
    echo "##################################"

    exit 1
  else

    echo "##################################"
    echo "##                              ##"
    echo "## Setting Up Cluster Success!  ##"
    echo "##                              ##"
    echo "##################################"

  fi
}

function set_up_plugins {
  CONFIG_JSON_PATH=$1
  CLUSTER_NAME=$2

  echo "##################################"
  echo "##                              ##"
  echo "##      Installing plugins      ##"
  echo "##                              ##"
  echo "##################################"

  PLUGINS_LIST=$(jq -rc '.plugins[]' "$CONFIG_JSON_PATH")

  for PLUGIN in $PLUGINS_LIST
  do
    echo -e "\n\nSetting up $PLUGIN..."
    minikube --profile "$CLUSTER_NAME" addons enable "$PLUGIN"


    if [[ $? != 0 ]]
    then
      echo "##################################"
      echo "##                              ##"
      echo "##  Installing Plugins Failed   ##"
      echo "## Please check the above logs! ##"
      echo "##                              ##"
      echo "##################################"

      exit 1
    else
    echo -e "\n\n$PLUGIN is installed"
    fi
  done

}

function install_operators {
  CONFIG_JSON_PATH=$1
  CLUSTER_NAME=$2

  echo "##################################"
  echo "##                              ##"
  echo "##     Installing Operators     ##"
  echo "##                              ##"
  echo "##################################"

  OPERATORS_LIST=$(jq -rc '.operators[] | @base64' "$CONFIG_JSON_PATH")

  for OPERATOR_HASHED in $OPERATORS_LIST
  do
    OPERATOR=$(echo "$OPERATOR_HASHED" | base64 --decode)
    OPERATOR_NAME=$(echo "$OPERATOR" | jq -rc '.name')
    OPERATOR_STEPS=$(echo "$OPERATOR" | jq -rc '.steps[] | @base64')

    echo "Installing Operator: $OPERATOR_NAME..."

    for STEP_HASHED in $OPERATOR_STEPS
    do
      STEP=$(echo "$OPERATOR_STEPS" | base64 --decode)

      echo "Executing step: $STEP"
      eval "${STEP}"

      if [[ $? != 0 ]]
      then
        echo "##################################"
        echo "##                              ##"
        echo "## Installing Operator Failed!  ##"
        echo "## Please check the above logs! ##"
        echo "##                              ##"
        echo "##################################"

        exit 1
      fi
    done

    echo -e "\n\n$OPERATOR_NAME is installed"
  done

}

# --------------------------------- SCRIPT START --------------------------------- #

CLUSTER_NAME=$(jq -rc '.cluster_name' "$CONFIG_JSON_PATH")

CHECK_CLUSTER_EXISTENCE=$(minikube profile list | grep -c "$CLUSTER_NAME" || true)

if [[ "$CHECK_CLUSTER_EXISTENCE" == "0" ]]
then
  set_up_cluster "$CONFIG_JSON_PATH"
  set_up_plugins "$CONFIG_JSON_PATH" "$CLUSTER_NAME"
fi

install_operators "$CONFIG_JSON_PATH" "$CLUSTER_NAME"
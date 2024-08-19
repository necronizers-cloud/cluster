#!/bin/bash

echo "##################################"
echo "##                              ##"
echo "##      Setting Up Cluster      ##"
echo "##                              ##"
echo "##################################"

minikube start --cpus 4 --memory 4GB --nodes 4 --driver docker

if [[ $? != 0 ]]
then
  echo "##################################"
  echo "##                              ##"
  echo "##  Setting Up Cluster Failed   ##"
  echo "## Please check the above logs! ##"
  echo "##                              ##"
  echo "##################################"

  exit 1
fi

echo "##################################"
echo "##                              ##"
echo "##      Installing plugins      ##"
echo "##                              ##"
echo "##################################"

minikube addons enable volumesnapshots
minikube addons enable csi-hostpath-driver
minikube addons enable yakd
minikube addons enable ingress

if [[ $? != 0 ]]
then
  echo "##################################"
  echo "##                              ##"
  echo "##  Installing Plugins Failed   ##"
  echo "## Please check the above logs! ##"
  echo "##                              ##"
  echo "##################################"

  exit 1
fi
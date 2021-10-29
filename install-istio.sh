#!/bin/bash

set -exuo pipefail

minikube delete
ISTIO_VERSION=${ISTIO_VERSION:1.6.14}
KUBERNETES_VERSION=${KUBERNETES_VERSION:v1.19.0}
minikube start --memory=15000 --cpus=3 --kubernetes-version=${KUBERNETES_VERSION}
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=x86_64 sh -
export PATH=$PWD/istio-$ISTIO_VERSION/bin:$PATH
istioctl version
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled

kubectl get cm kiali -n istio-system -o yaml > kialicm.yaml
sed -i 's/strategy: login/strategy: anonymous/' kialicm.yaml
kubectl apply -f kialicm.yaml
export KIALI_POD=$(kubectl get pods -l app=kiali -n istio-system -o 'jsonpath={.items[0].metadata.name}')
kubectl delete pod $KIALI_POD -n istio-system

sudo apt get install socat
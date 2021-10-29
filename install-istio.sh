#!/bin/bash

set -exuo pipefail

minikube delete
rm ./istio-*/ -Rf
ISTIO_VERSION=${ISTIO_VERSION:-1.6.14}
KUBERNETES_VERSION=${KUBERNETES_VERSION:-v1.19.0}
#ISTIO_VERSION=${ISTIO_VERSION:-1.11.4}
#KUBERNETES_VERSION=${KUBERNETES_VERSION:-v1.22.0}
minikube start --memory=15000mb --cpus=3 --kubernetes-version=$KUBERNETES_VERSION
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION TARGET_ARCH=x86_64 sh -
export PATH=$PWD/istio-$ISTIO_VERSION/bin:$PATH
istioctl version
istioctl install --set profile=demo -y

if ! kubectl -n istio-system get svc kiali; then
    kubectl apply -f ./istio-$ISTIO_VERSION/samples/addons -n istio-system
fi

kubectl label namespace default istio-injection=enabled
kubectl get cm kiali -n istio-system -o yaml > kialicm.yaml
sed -i 's/strategy: login/strategy: anonymous/' kialicm.yaml
kubectl apply -f kialicm.yaml
export KIALI_POD=$(kubectl get pods -l app=kiali -n istio-system -o 'jsonpath={.items[0].metadata.name}')
kubectl delete pod $KIALI_POD -n istio-system

sudo apt install socat
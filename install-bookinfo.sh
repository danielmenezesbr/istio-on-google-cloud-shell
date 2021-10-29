#!/bin/bash

set -exuo pipefail
./istio-*/bin/istioctl version
kubectl apply -f ./istio-*/samples/bookinfo/platform/kube/bookinfo.yaml
echo "Wait for Bookinfo"
while [ "$(kubectl get pods | wc -l)" != "7" ]
do
    echo -n '.'
    sleep 1
done
kubectl wait --for=condition=ready pod -l app=productpage --timeout=120s
kubectl wait --for=condition=ready pod -l app=details --timeout=120s
kubectl wait --for=condition=ready pod -l app=reviews --timeout=120s
kubectl wait --for=condition=ready pod -l app=ratings --timeout=120s
sleep 5
# test productpage inside ratings
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
pwd
source istio-env.sh
kubectl apply -f ./istio-*/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl get gateway
sleep 5
# test productpage using gateway
curl -s "http://${GATEWAY_URL}/productpage" | grep -o "<title>.*</title>"
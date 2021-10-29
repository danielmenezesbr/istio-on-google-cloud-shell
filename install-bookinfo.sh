#!/bin/bash

set -exuo pipefail
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
echo "Wait for Bookinfo"
while [ "$(kubectl get pods | wc -l)" != "7" ]
do
    echo -n '.'
    sleep 5
done
kubectl wait --for=condition=ready pod -l app=productpage --timeout=120s
kubectl wait --for=condition=ready pod -l app=details --timeout=120s
kubectl wait --for=condition=ready pod -l app=reviews --timeout=120s
kubectl wait --for=condition=ready pod -l app=ratings --timeout=120s
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].nodePort}')
export INGRESS_HOST=$(minikube ip)
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl get gateway
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
sleep 5
curl -s "http://${GATEWAY_URL}/productpage" | grep -o "<title>.*</title>"
# kill all the child processes for this script when it exits
trap 'jobs=($(jobs -p)); [ -n "${jobs-}" ] && ((${#jobs})) && kill "${jobs[@]}" || true' EXIT

echo "Setting port-forward for Kiali, Grafana, Jaeger, Prometheus and Bookinfo"
kubectl -n istio-system port-forward svc/kiali 8080:20001 >> port-forward.log 2>&1 &
kubectl -n istio-system port-forward svc/grafana 8081:3000 >> port-forward.log 2>&1 &
kubectl -n istio-system port-forward svc/tracing 8082:80 >> port-forward.log 2>&1 &
kubectl -n istio-system port-forward svc/prometheus 8083:9090 >> port-forward.log 2>&1 &
source istio-env.sh
socat -d -d TCP4-LISTEN:8084,fork TCP4:$GATEWAY_URL >> port-forward.log 2>&1 &
echo "Port forwarding is ready."
source show-web-preview.sh
echo "Control + C to stop port-forward and exit."

read -r -d '' _ </dev/tty
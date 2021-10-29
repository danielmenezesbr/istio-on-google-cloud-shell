set +x

uri_web_preview () {
  ZONE=$(curl -s -H "Metadata-Flavor: Google" metadata/computeMetadata/v1/instance/zone)
  ZONE="${ZONE##*/}"
  REGION=${ZONE%-*}
  MACHINE=$(hostname)
  MACHINE="${MACHINE%-default*}-default"
  PORT=$1
  echo "https://${PORT}-${MACHINE}.cs-${REGION}-vpcf.cloudshell.dev/"
}

echo "=========================================================="
echo "To access Kiali, Grafana, Jaeger, Prometheus and Bookinfo use the links below:"
echo "     Kiali (port 8080): $(uri_web_preview '8080')"
echo "   Grafana (port 8081): $(uri_web_preview '8081')"
echo "    Jaeger (port 8082): $(uri_web_preview '8082')"
echo "Prometheus (port 8083): $(uri_web_preview '8083')"
echo "  Bookinfo (port 8084): $(uri_web_preview '8084')productpage"
echo ""
echo "To access Bookinfo via curl from Google Cloud Shell:"
echo "source ~/istio-on-google-cloud-shell/istio-env.sh"
echo "curl -s "http://${GATEWAY_URL}/productpage" | grep -o \"<title>.*</title>\""
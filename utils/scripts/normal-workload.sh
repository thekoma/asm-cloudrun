#!/bin/bash
MODULE=${1:-module-001}
EXTERNAL_IP=$(kubectl -n istio-system get svc istio-ingressgateway     -o jsonpath='{.status.loadBalancer.ingress[0].ip}' | tee external-ip.txt)
curl \
  -s \
  -X POST \
  --header "Content-Type: application/json" \
  -d @payload.json \
  http://frontend.default.kuberun.${EXTERNAL_IP}.nip.io/api/${MODULE}


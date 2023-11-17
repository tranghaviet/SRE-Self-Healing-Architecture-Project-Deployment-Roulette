#!/bin/bash

set -e

cd starter/apps/blue-green

kubectl apply -f index_green_html.yml

kubectl apply -f green.yml
# Wait for the deployment to roll out
kubectl rollout status deployment/green

# Wait for the service to be reachable
kubectl wait --for=condition=available --timeout=300s deployment/green

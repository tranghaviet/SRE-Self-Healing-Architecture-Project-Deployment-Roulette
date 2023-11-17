#!/bin/bash

set -e

# Optional: comment out the current version of the canary app
# sed -i 's/version: "1.0"/# version: "1.0"/' starter/apps/canary/canary-svc.yml

kubectl apply -f starter/apps/canary/index_v2_html.yml
kubectl apply -f starter/apps/canary/canary-svc.yml
# Initialize canary-v2 deployment
kubectl apply -f starter/apps/canary/canary-v2.yml

# show services
kubectl get service canary-svc

DEPLOY_INCREMENTS=1
DEPLOY_SUCCESSFUL_COUNT=1
NUM_OF_V1_PODS=$(kubectl get pods -n udacity | grep -c canary-v1)
echo "V1 PODS: $NUM_OF_V1_PODS"

function canary_deploy {
  NUM_OF_V2_PODS=$(kubectl get pods -n udacity | grep -c canary-v2)
  echo "V2 PODS: $NUM_OF_V2_PODS"

  kubectl scale deployment canary-v2 --replicas=$((NUM_OF_V2_PODS + $DEPLOY_INCREMENTS))
  # Check deployment rollout status every 1 second until complete.
  ATTEMPTS=0
  ROLLOUT_STATUS_CMD="kubectl rollout status deployment/canary-v2 -n udacity"
  until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
    $ROLLOUT_STATUS_CMD
    ATTEMPTS=$((attempts + 1))
    sleep 1
  done

  DEPLOY_SUCCESSFUL_COUNT=$((DEPLOY_SUCCESSFUL_COUNT + 1))
  echo "Canary deployment of $DEPLOY_INCREMENTS replicas successful!"
}

# Begin canary deployment
while [ "$DEPLOY_SUCCESSFUL_COUNT" -lt "$NUM_OF_V1_PODS" ]
do
  canary_deploy
done

echo "Canary deployment of v2 successful"

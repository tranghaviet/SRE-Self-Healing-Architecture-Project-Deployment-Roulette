# Step 1: Deployment Troubleshooting

Add / update `app/hello-world/hello.yaml` like in `deployment-troubleshooting.png`.

Then run
```sh
kubectl apply -f starter/apps/hello-world
```

Check if the pod is healthy:

```sh
kubectl get pods --namespace udacity
kubectl logs hello-world-5999896d6f-mb2vn
```

Result `hello-world pod healthy.png`

# Step 2: Canary Deployments

Comment out the current version of the canary app
```sh
sed -i 's/version: "1.0"/# version: "1.0"/' starter/apps/canary/canary-svc.yml
```

Please check result files: `canary2.txt`, `canary.txt`, `canary.sh`.

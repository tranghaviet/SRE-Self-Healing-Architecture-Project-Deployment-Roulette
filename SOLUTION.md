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

# Step 3: Blue-green Deployments

| Note: The resource `aws_route53_zone` had name `udacityproject` but the project
| wants to use `udacityproject.com` so we have to update it to `udacityproject.com`
| in `starter/infra/dns.tf`

```
./blue-green.sh
cd starter/infra
# Check wether terraform plan is correct
terraform plan
terraform apply -auto-approve
# Get services
kubectl get svc
```

Fix DNS record

```sh
sed -i 's/udacityproject/udacityproject.com/' `starter/infra/dns.tf`
terraform init -reconfigure -upgrade
terraform apply -auto-approve
```

Connect to EC2 `curl-instance` then run `for i in {1..10}; do curl blue-green.udacityproject.com; sleep 2; done`

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

# Step 4: Node Elasticity
Fail reason: `bloatware-fail-reason.png`

After we identify the problem using `kubectl describe pod bloaty-mcbloatface-66dd4b7b5b-24cqf` command we know the reason is

```
0/2 nodes are available: 2 Insufficient cpu. preemption: 0/2 nodes are available: 2 No preemption victims found for incoming pod..
```

To resolve this problem we have a few options

1. Increase the CPU capacity of the cluster node size in `starter/infra/eks.tf`

```
nodes_desired_size = 4
nodes_max_size     = 10
nodes_min_size     = 1
```

Then run terraform apply again

```sh
terraform init -reconfigure -upgrade
terraform apply -auto-approve
```

2. Modify the resource requirements of our pod: If our pod's CPU resource requests are too high, we can try reducing them to make it easier for the scheduler to find available nodes. We can modify the section of our pod's YAML file and decrease section of our pod's YAML file and decrease the `resources` value: `requests.cpu`

Edit `starter/apps/bloatware/bloatware.yml`

```
...
              memory: "100Mi"
              cpu: "100m"
...
```

# perf

Docker version of https://github.com/intel/PerfSpect . TODO with added Prometheus scrapping and Grafana dashboard.

## Design

Container in pods on worker nodes will run ```perfspect report``` and send result to the aggregator which will expose web port 8080 to provide it to curl and web clients.

## (Optional) Prepare

Build with

```
cd build
./build.sh
```

Set environment variable IMAGEREPOUSER to your Docker Hub username, and publish container image to Docker Hub with

```
export IMAGEREPOUSER=yourdockerhubusername
./push.sh
```

or do similar for another container image repository.

In [start.sh](./start.sh) update image name to point to where you pushed it.

## (Option 1) With Kubernetes

### Run

Run it with:

```
cd k8s
kubectl apply -f 0-ns.yaml
kubectl apply -f 1-aggregator.yaml
kubectl apply -f 2-collectors.yaml
```

### Stop

```
cd k8s
kubectl delete -f 0-ns.yaml
```

which will stop all pods, services and delete the namespace.

## CHECK AGAIN (Option 2) With Docker Engine

### Run

Run it with:

```
./start.sh
```

which will in console also present Perfspect metrics (as needed change number of rows in terminal).

See Perfspect reports with

```
curl http://localhost:8080/list.php
```

which will give list of worker nodes, then

```
curl http://localhost:8080/worker-node-1.txt
```

or

```
curl http://localhost:8080/worker-node-2.json
```

## Stop

### (Option 2)

Stop all containers with:

```
./stop.sh
```

which if started with scripts above will also remove those containers.

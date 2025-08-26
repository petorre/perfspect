# perfspect

Containerized version of https://github.com/intel/PerfSpect scheduled with Kubernetes.

## Design

Container in pods on worker nodes will run ```perfspect report``` and send result to the aggregator which will expose web port 8080 to provide it to curl and web clients.

## (Optional) Prepare

Build with

```
cd build
./build.sh
```

Check names in [config](./config), and publish container image to Docker Hub with

```
./push.sh
```

or do similar for another container image repository.

In [2-collectors.yaml](./k8s/2-collectors.yaml) update image name.

## Run

Run it with:

```
cd k8s
kubectl apply -f 0-ns.yaml
kubectl apply -f 1-aggregator.yaml
kubectl apply -f 2-collectors.yaml
```

After short time:

```
curl http://localhost:8080/list.php
```

or similar with web browser will give you the list of available reports.

Get human-readable version of the report with:

```
curl http://localhost:8080/yournodename.txt
```

or machine-readable JSON with:

```
curl http://localhost:8080/yournodename.json
```

## Stop

```
cd k8s
kubectl delete -f 0-ns.yaml
```

which will stop all pods, services and delete the namespace.


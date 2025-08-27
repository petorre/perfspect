# perfspect report

Kubernetes-scheduled containerized version of [Intel PerfSpect](https://github.com/intel/PerfSpect) tool for detailed HW+OS reports.

## Design

Container in pods on worker nodes will run ```perfspect report``` and send result to the aggregator which will expose web port 8080 to provide it to curl and web clients.

The collector container runs as privileged or it will not be able to collect all details like BIOS or DIMMs.

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
kubectl apply -f 0-ns.yaml -f 1-aggregator.yaml -f 2-collectors.yaml
```

After a minute or two:

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
curl -s http://localhost:8080/yournodename.json
```

Example run:

```
$ curl -s http://localhost:8080/$(hostname).json | jq -r ' ."System Summary"[]."System Summary" '
1-node, OEM_Name Server_Model_123, 2x Intel(R) Xeon(R) 6767P, 64 cores, 350W TDP, HT On, Turbo On, Total Memory 512GB (16x32GB DDR5 6400MT/s [6400MT/s]), BIOS Name_123, microcode 0x1234567, 1x , 1x 476.9G Disk_Vendor Disk_Name_123, Ubuntu 24.04.3 LTS, 6.14.0-27-generic. Test with Intel PerfSpect as of August 27 2025.
```

## Stop

```
cd k8s
kubectl delete -f 0-ns.yaml
```

which will stop all pods, services and delete the namespace.


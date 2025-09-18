#! /bin/bash

set -e # x

elb=$( kubectl get svc -n perfspect -o json | jq -r ' .items[] | select ( .metadata.name == "aggregator-lb" ) | .status.loadBalancer.ingress[].hostname ' )
echo "["
first=1
for r in $( curl -s "http://${elb}:8080/list.php" | grep ".json" ); do
    if [[ $first -eq 1 ]]; then
        first=0
    else
        echo ","
    fi
    echo "  { \"node\": \"${r}\","
    ss=$( curl -s "http://${elb}:8080/${r}" | jq -r ' ."System Summary"[]."System Summary" ' )
    echo -n "    \"system_summary\": \"${ss}\" }"
done
echo
echo "]"

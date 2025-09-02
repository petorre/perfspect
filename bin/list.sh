#!/bin/bash

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

set -e

kg_svc_items=$( kubectl get svc -n perfspect -o json | jq -r ' .items[] ' )
aggr=$( echo "${kg_svc_items}" | jq -r ' select ( .metadata.name == "aggregator" ) | .spec.clusterIP ' )
port=$( echo "${kg_svc_items}" | jq -r ' select ( .metadata.name == "aggregator" ) | .spec.ports[].port ' )
echo curl -s "http://${aggr}:${port}/list.php"
curl -s "http://${aggr}:${port}/list.php"

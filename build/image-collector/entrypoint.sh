#! /bin/bash

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

set -e

if [[ -z "${SLEEP}" ]]; then
    SLEEP=60
fi

HOSTNAME=$( hostname )
if [[ -z "${NODE_NAME}" ]]; then
    NODE_NAME="${HOSTNAME}"
fi

mkdir /root/perfspect
cd /root/perfspect

mkdir results

while [[ 1 ]]; do
    perfspect report --log-stdout --noupdate --output results --format json,txt 1>> /dev/null 2>> /dev/null
    for f in "json" "txt"; do
        sed -i "s/${HOSTNAME}/${NODE_NAME}/g" results/*.${f}
        if [[ ! -z "${AGGREGATOR_ENDPOINT}" ]]; then
            curl -X POST "${AGGREGATOR_ENDPOINT}" \
                -F "filename=${NODE_NAME}.${f}" \
                -F "content=$( base64 -w 0 results/*.${f} )"
            echo "Posted report to aggregator"
        fi
    done
    sleep "${SLEEP}"
done

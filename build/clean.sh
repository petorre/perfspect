#! /bin/bash -v

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

set -e

source config

for n in "${COLLECTOR_IMAGENAME}" "${AGGREGATOR_IMAGENAME}"; do
    is=$( docker image ls | awk -vPI="${n}" -vRUPI="${IMAGEREPOUSER}/${n}" ' $1==PI || $1==RUPI { print $3 } ' | sort -u )
    for i in "${is}"; do
        docker rmi -f ${i}
    done
done

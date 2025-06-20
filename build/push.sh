#!/bin/bash -v

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

source config

for n in "${COLLECTOR_IMAGENAME}" "${AGGREGATOR_IMAGENAME}"; do
    docker rmi -f "${IMAGEREPOUSER}/${n}"
    docker tag "${n}" "${IMAGEREPOUSER}/${n}"
    docker push "${IMAGEREPOUSER}/${n}"
done

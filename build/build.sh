#!/bin/bash -v

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

set -ex

source config

for n in "${COLLECTOR_IMAGENAME}" "${AGGREGATOR_IMAGENAME}"; do
    docker build --build-arg "hosttype=${HOSTTYPE}" -t "${n}-${HOSTTYPE}" -f "Dockerfile-${n}" .
done

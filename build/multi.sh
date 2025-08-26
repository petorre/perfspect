#!/bin/bash -v

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

source config

# create manifest if there are images for two machine types
for i in "${COLLECTOR_IMAGENAME}" "${AGGREGATOR_IMAGENAME}"; do
    b="${IMAGEREPOUSER}/${i}"
    ml=` docker search "${b}-" | awk -vI="${b}" ' $1~I { printf("%s ",$1) } ' `
    if [ ` echo ${ml} | wc -w ` -ne 2 ]; then
        echo "Error: Need 2 arch for ${b} image but found only ${ml}. Exiting."
    fi

done


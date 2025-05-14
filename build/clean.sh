#! /bin/bash -v

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

set -e

source config

is=$( docker image ls | awk -vLI="${LLM_IMAGENAME}" -vJI="${JMETER_IMAGENAME}" -vRULI="${IMAGEREPOUSER}/${LLM_IMAGENAME}" -vRUJI="${IMAGEREPOUSER}/${JMETER_IMAGENAME}" ' $1==LI || $1==JI || $1==RULI || $1==RUJI { print $3 } ' | sort -u )
for i in "${is}"; do
    docker rmi -f ${i}
done

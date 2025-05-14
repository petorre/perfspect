#!/bin/bash -v

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

set -e

source config

#if [[ ! -e ollama ]]; then
#    git clone https://github.com/ollama/ollama
#fi

#for i in ${LLM_IMAGENAME} ${JMETER_IMAGENAME}; do
#    if [[ "${1}" == "--no-cache" ]]; then
#        docker build --no-cache -t "${i}" -f "Dockerfile-${i}" .
#    else
#        docker build -t "${i}" -f "Dockerfile-${i}" .
#    fi
#done

docker build -t "${PERF_IMAGENAME}" -f Dockerfile .

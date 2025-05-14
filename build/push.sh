#!/bin/bash -v

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

IMAGENAME="perf"

if [[ -z "${IMAGEREPOUSER}" ]]; then
    echo "Set env var IMAGEREPOUSER. Exiting..."
    exit
fi

if [[ $( echo "${IMAGEREPOUSER}" | grep -c "ecr.aws" ) -eq 1 ]]; then
    aws ecr-public get-login-password --region us-east-1 | docker login \
        --username AWS --password-stdin "${IMAGEREPOUSER}"
fi

docker rmi -f "${IMAGEREPOUSER}/${IMAGENAME}"
docker tag "${IMAGENAME}" "${IMAGEREPOUSER}/${IMAGENAME}"
docker push "${IMAGEREPOUSER}/${IMAGENAME}"

#!/bin/bash -v

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

source config

docker rmi -f "${IMAGEREPOUSER}/${PERFSPECT_IMAGENAME}"
docker tag "${PERFSPECT_IMAGENAME}" "${IMAGEREPOUSER}/${PERFSPECT_IMAGENAME}"
docker push "${IMAGEREPOUSER}/${PERFSPECT_IMAGENAME}"

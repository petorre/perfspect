#!/bin/bash -v

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

set -e

source config

docker build -t "${PERFSPECT_IMAGENAME}" -f Dockerfile .

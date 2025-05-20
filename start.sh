#! /bin/bash -v

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

#if [[ -z "$1" ]]; then
#    PN="ALL"
#else
#    PN="$1"
#fi

# without exposing counters on :80
# docker run -e PN="${PN}" --name=processwatch --rm -it --privileged ptorre/processwatch:20250405

#docker run -e PN="${PN}" -it --rm --name=perf --network=host --privileged ptorre/perfspect
docker run -it --rm --name=perf --network=host --privileged ptorre/perfspect

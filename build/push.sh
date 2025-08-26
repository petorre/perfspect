#!/bin/bash

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

set -ex

source config

for n in "${COLLECTOR_IMAGENAME}" "${AGGREGATOR_IMAGENAME}"; do
    docker rmi -f "${IMAGEREPOUSER}/${n}-${HOSTTYPE}"
    docker tag "${n}-${HOSTTYPE}" "${IMAGEREPOUSER}/${n}-${HOSTTYPE}"
    docker push "${IMAGEREPOUSER}/${n}-${HOSTTYPE}"
done

# create manifest for one or two machine types
for n in "${COLLECTOR_IMAGENAME}" "${AGGREGATOR_IMAGENAME}"; do
    mnfst="${IMAGEREPOUSER}/${n}"
    imgx86="${mnfst}-x86_64"
    imgarm="${mnfst}-aarch64"
    dsix86=$( docker search "${imgx86}" | awk -vI="${imgx86}" ' I~$1 { print $1; } ' )
    dsiarm=$( docker search "${imgarm}" | awk -vI="${imgarm}" ' I~$1 { print $1; } ' )
    if [ "${dsix86}" != "" ] || [ "${dsarm}" != ""]; then
	docker manifest rm "${mnfst}"
        docker manifest create "${mnfst}" "${imgx86}" "${imgarm}"
        docker manifest push "${mnfst}"
    fi
done


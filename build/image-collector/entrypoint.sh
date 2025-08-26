#! /bin/bash

# Copyright (C) 2025 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

set -e

if [[ -z "${SLEEP}" ]]; then
    SLEEP=60
fi

HOSTNAME=$( hostname )
if [[ -z "${NODE_NAME}" ]]; then
    NODE_NAME="${HOSTNAME}"
fi

mkdir /root/perfspect
cd /root/perfspect

mkdir results

while [[ 1 ]]; do
    perfspect report --noupdate --output results --format json,txt 1>> /dev/null 2>> /dev/null
    for f in "json" "txt"; do
        sed -i "s/${HOSTNAME}/${NODE_NAME}/g" results/*.${f}
        if [[ ! -z "${AGGREGATOR_ENDPOINT}" ]]; then
            curl -X POST "${AGGREGATOR_ENDPOINT}" \
                -F "filename=${NODE_NAME}.${f}" \
                -F "content=$( base64 -w 0 results/*.${f} )"
        fi
    done
    sleep "${SLEEP}"
done

#
# NEVER REACHED
#

# in Docker Engine, not in Kubelet
if [[ "${CONF_KERNEL}" == "true" ]]; then
    sysctl -w kernel.perf_event_paranoid=0 >> /dev/null
    sysctl -w kernel.nmi_watchdog=0 >> /dev/null
    for i in $(find /sys/devices -name perf_event_mux_interval_ms); do
        echo 125 > $i >> /dev/null
    done
fi

touch /tmp/ready

while [[ "${METRICS}" == "true" ]]; do
    perfspect metrics --noupdate --noroot --duration 10 --output results 1>> /dev/null 2>> /dev/null
    sed "s/ /_/g" < results/*_metrics_summary.csv | awk -vFS="," ' NR>=2 { printf("%s %s\n",$1,$2); } ' > "${webdir}/metrics"
    clear
    echo -n "# "
    date
    sed "s/ /_/g" < results/*_metrics_summary.csv | awk -vFS="," ' NR>=2 { if ($2>0 && $2!="NaN") printf("%s %s\n",$1,$2); } '
    #awk -vPN="${PN}" ' NR==1 { split($0,f,","); l=length(f); } NR>=2 { split($0,a,","); if (a[3]==PN) for (i=0;i<l;i++) s[i]+=a[i]; } END { for (i=0;i<l;i++) if (s[i]>0 && f[i]!="pid") printf("%s: %s\n",f[i],s[i]); } ' pw | sort -n -k2 -r > metrics
    #awk ' { if ( $1 ~ "AES-NI" || $1 ~ "AVX" || $1 ~ "AMX" ) print "\033[44m"$0"\033[0m"; else print $0; } ' metrics
    rm -f results/*
    sleep 1
done

touch /tmp/done
echo "done"
sleep infinity

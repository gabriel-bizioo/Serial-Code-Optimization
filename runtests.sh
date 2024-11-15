#!/bin/bash

N=(64 100 128 1024);

LIKWID_CMD="likwid-perfctr -m -C $2 -g"

echo "performance" > /sys/devices/system/cpu/cpufreq/policy${1}/scaling_governor

make purge matmult
rm *.dat

for value in "${N[@]}"
do
    echo "testing for n=$value..."

    ${LIKWID_CMD} L3CACHE $1 $value |
        awk -F'|' '$2 ~ /L3 miss ratio/ {print '$value' $3}' >> l3.dat

    ${LIKWID_CMD} ENERGY $1 $value |
        awk -F'|' '$2 ~ /Energy PP0/ {print '$value' $3}' >> energy.dat

    ${LIKWID_CMD} FLOPS_DP $1 $value |
        awk -F'|' '$2 ~ /DP/ {print $2 $3}' |
        awk '$1 !~ /AVX/ {print '$value' $3}' >> flops.dat
    echo "done."
done

echo "powersave" > /sys/devices/system/cpu/cpufreq/policy${1}/scaling_governor

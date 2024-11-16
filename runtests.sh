#!/bin/bash

N=(64 100 128 1024 2000 3000 4000 6000 7000 10000);

LIKWID_CMD="likwid-perfctr -m -C $2 -g"

echo "performance" > /sys/devices/system/cpu/cpufreq/policy${1}/scaling_governor

make purge matmult
rm *.dat

for value in "${N[@]}"
do
    echo "testing for n=$value..."

    awk 'BEGIN {ORS=" "; print '$value'}' >> l3.dat
    awk 'BEGIN {ORS=" "; print '$value'}' >> energy.dat
    awk 'BEGIN {ORS=" "; print '$value'}' >> flops.dat

    ${LIKWID_CMD} L3CACHE $1 $value |
        awk -F'|' 'BEGIN {ORS=" "}; $2 ~ /L3 miss ratio/ {gsub (" ", "", $3); print $3}' >> l3.dat
    echo "" >> l3.dat

    ${LIKWID_CMD} ENERGY $1 $value |
        awk -F'|' '$2 ~ /Energy/ {gsub (" ", "", $3); print $3}' | awk 'BEGIN {ORS=" "}; (NR-1) % 4 == 0 {print}' >> energy.dat
    echo "" >> energy.dat

    ${LIKWID_CMD} FLOPS_DP $1 $value |
        awk -F'|' '$2 ~ /DP/ {print $2 $3}' |
        awk 'BEGIN {ORS=" "}; $1 !~ /AVX/ {print $3}' >> flops.dat
    echo "" >> flops.dat

    echo "done."
done

echo "powersave" > /sys/devices/system/cpu/cpufreq/policy${1}/scaling_governor

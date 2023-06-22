#!/usr/bin/bash

# Run the sorting and tabix on the output of "run-normalize-tsv.sh"

set -euo pipefail
set -x

mkdir -p ${OUTPUT_DIR}/${GENOME_RELEASE}/strucvar/sorted

INPUT=${OUTPUT_DIR}/${GENOME_RELEASE}/strucvar/parsed/output.tsv

head -n 1 $INPUT \
> ${OUTPUT_DIR}/${GENOME_RELEASE}/strucvar/sorted/output.tsv

tail -n +2 $INPUT \
| sort -k2,2V -k3,3n -k4,4n -k11,11 \
>> ${OUTPUT_DIR}/${GENOME_RELEASE}/strucvar/sorted/output.tsv

head -n 2 ${OUTPUT_DIR}/${GENOME_RELEASE}/strucvar/sorted/output.tsv

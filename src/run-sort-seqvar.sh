#!/usr/bin/bash

# Run the sorting and tabix on the output of "run-normalize-tsv.sh"

set +e
set -uo pipefail
set -x

mkdir -p ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/sorted

INPUT=${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/normalized/output.tsv
bgzip -d $INPUT.bgz

head -n 1 $INPUT \
> ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/sorted/output.tsv

tail -n +2 $INPUT \
| sort -k2,2V -k3,3n -k4,4n -k11,11 \
>> ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/sorted/output.tsv

head -n 2 ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/sorted/output.tsv

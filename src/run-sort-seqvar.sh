#!/usr/bin/bash

# Run the sorting and tabix on the output of "run-normalize-tsv.sh"

set +e
set -uo pipefail
set -x

mkdir -p ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/sorted

INPUT=${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/normalized/output.tsv.bgz

zcat $INPUT \
| head -n 1 \
> ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/sorted/output.tsv

zcat $INPUT \
| tail -n +2 \
| sort -k2,2V -k3,3n -k4,4n -k11,11) \
| bgzip -c \
>> ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/sorted/output.tsv

bgzip ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/sorted/output.tsv

tabix -S 1 -s 2 -b 3 -e 4 -f \
    ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/sorted/output.tsv.bgz

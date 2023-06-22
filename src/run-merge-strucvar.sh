#!/usr/bin/bash

# Run "clinvar_tsv normalize_tsv" on the output of "run-parse-xml.sh"

set -euo pipefail
set -x

mkdir -p ${OUTPUT_DIR}/${GENOME_RELEASE}/strucvar/merged

zcat ${OUTPUT_DIR}/${GENOME_RELEASE}/strucvar/sorted/output.tsv.bgz \
| clinvar_tsv merge_tsvs \
    --clinvar-version {params.clinvar_version} \
    --input-tsv /dev/stdin \
    --output-tsv /dev/stdout \
| bgzip -c \
> ${OUTPUT_DIR}/${GENOME_RELEASE}/strucvar/merged/output.tsv.bgz

tabix -S 1 -s 2 -b 3 -e 4 \
    -f ${OUTPUT_DIR}/${GENOME_RELEASE}/strucvar/merged/output.tsv.bgz

ls -lhR ${OUTPUT_DIR}

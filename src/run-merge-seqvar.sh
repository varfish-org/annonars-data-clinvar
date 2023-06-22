#!/usr/bin/bash

# Run "clinvar_tsv merge_tsvs" on sorted variants.

set -euo pipefail
set -x

mkdir -p ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/merged

clinvar_tsv merge_tsvs \
    --clinvar-version {params.clinvar_version} \
    --input-tsv ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/sorted/output.tsv \
    --output-tsv ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/merged/output.tsv

ls -lhR ${OUTPUT_DIR}

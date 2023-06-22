#!/usr/bin/bash

# Perform the annonars import

set -euo pipefail
set -x

mkdir -p ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/annonars-import

annonars clinvar-minimal import \
    --genome-release ${GENOME_RELEASE} \
    --path-in-tsv ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/annonars-import/output.tsv \
    --path-out-rocksdb ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/annonars-import/rocksdb

ls -lhR ${OUTPUT_DIR}

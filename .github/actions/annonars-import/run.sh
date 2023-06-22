#!/usr/bin/bash

# Perform the annonars import

set -euo pipefail
set -x

mkdir -p ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/annonars-import

genome_release=$(echo ${GENOME_RELEASE} | tr '[:upper:]' '[:lower:]')

annonars clinvar-minimal import \
    --genome-release $genome_release \
    --path-in-tsv ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/merged/output.tsv \
    --path-out-rocksdb ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/annonars-import/rocksdb

cat >${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/annonars-import/spec.yaml <<EOF
dc.identifier: annonars/clinvar-${CLINVAR_RELEASE/-/}+$CLINVAR_TSV_VERSION+$ANNONARS_VERSION
dc.title: annonars ClinVar database
dc.creator: NCBI ClinVar Team
dc.contributor:
  - VarFish Development Team
dc.format: application/x-rocksdb
dc.date: $(date +%Y%m%d)
x-version: ${CLINVAR_RELEASE/-/}+$CLINVAR_TSV_VERSION+$ANNONARS_VERSION
x-genome-release: $genome_release
dc.description: |
  RocksDB with the information from ClinVar weekly release ${CLINVAR_RELEASE},
  created using clinvar-tsv v${CLINVAR_TSV_VERSION} and annonars
  v${ANNONARS_VERSION}.
dc.source:
  - PMID:32461654
  - https://gnomad.broadinstitute.org/
  - https://github.com/bihealth/annonars-data-clinvar
x-created-from:
  - name: ClinVar weekly release
    version: $CLINVAR_RELEASE
EOF

ls -lhR ${OUTPUT_DIR}

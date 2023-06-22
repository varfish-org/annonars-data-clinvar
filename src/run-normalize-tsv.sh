#!/usr/bin/bash

# Run "clinvar_tsv normalize_tsv" on the output of "run-parse-xml.sh"

set -euo pipefail
set -x

mkdir -p ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/normalized

clinvar_tsv normalize_tsv \
    --reference $(if [[ "${GENOME_RELEASE}" == "GRCh37" ]]; then \
        echo $REF_DIR/hs37d5.fa; \
    else \
        echo $REF_DIR/GRCh38_no_alt_analysis_set.fa; \
    fi) \
    --input-tsv ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/parsed/output.tsv \
    --output-tsv /dev/stdout \
| grep -v ^$ \
| bgzip -c \
>${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/normalized/output.tsv.bgz

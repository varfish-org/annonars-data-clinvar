#!/usr/bin/bash

# Run "clinvar_tsv parse_xml" on the ClinVar XML file.

set -euo pipefail
set -x

mkdir -p ${OUTPUT_DIR}/GRCh3{7,8}/{seqvar,strucvar}/parsed

clinvar_tsv parse_xml \
    --clinvar-xml ${CLINVAR_DIR}/ClinVarFullRelease_${CLINVAR_RELEASE}.xml.gz \
    --output-b37-small ${OUTPUT_DIR}/GRCh37/seqvar/parsed/output.tsv \
    --output-b37-sv ${OUTPUT_DIR}/GRCh37/strucvar/parsed/output.tsv \
    --output-b38-small ${OUTPUT_DIR}/GRCh38/seqvar/parsed/output.tsv \
    --output-b38-sv ${OUTPUT_DIR}/GRCh38/strucvar/parsed/output.tsv \
    $(if [[ "$MAX_RCVS" != "" ]] && [[ "$MAX_RCVS" != "0" ]]; then \
        echo --max-rcvs $MAX_RCVS;
    fi)

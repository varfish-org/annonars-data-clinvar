#!/usr/bin/bash

# Run "clinvar_tsv normalize_tsv" on the output of "run-parse-xml.sh"

set -euo pipefail
set -x

# TODO: remove once stable
pushd /tmp
/home/runner/micromamba-bin/micromamba remove -y clinvar-tsv
git clone https://github.com/bihealth/clinvar-tsv.git
cd clinvar-tsv
pip install .
popd

mkdir -p ${OUTPUT_DIR}/GRCh3{7,8}/{seqvar,strucvar}

clinvar_tsv normalize_tsv \
    --reference $(if [[ "$GENOME_RELEASE" == "GRCh37"]]; then
        echo $REF_DIR/hs37d5.fa; \
    else \
        echo $REF_DIR/GRCh38_no_alt_analysis_set.fa; \
    fi) \
    --input-tsv ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/parsed.tsv \
    --output-tsv ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/normalized.tsv

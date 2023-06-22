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

mkdir -p ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/merged

zcat ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/sorted/output.tsv.bgz \
| clinvar_tsv merge_tsvs \
    --clinvar-version {params.clinvar_version} \
    --input-tsv /dev/stdin \
    --output-tsv /dev/stdout \
| bgzip -c \
> ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/merged/output.tsv.bgz

tabix -S 1 -s 2 -b 3 -e 4 \
    -f ${OUTPUT_DIR}/${GENOME_RELEASE}/seqvar/merged/output.tsv.bgz

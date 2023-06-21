#!/usr/bin/bash

set -euo pipefail
set -x

export TMPDIR=$(mktemp -d)
export REF=/var/local/annonars-data-clinvar/references

clinvar_tsv main \
    --b37-path $REF/hs37d5.fa \
    --b38-path $REF/GRCh38_no_alt_analysis_set.fa \
    --clinvar-version $(cat $PWD/clinvar-release.txt || echo 2023-0617)

find .

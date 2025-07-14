#!/usr/bin/bash

set -euo pipefail
set -x

mkdir -p $CLINVAR_JSONL_DIR

export TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT ERR

df -h

# Download the pre-digested JSONL files

URL=$(gh release view -R varfish-org/clinvar-data-jsonl --json assets   -q '.assets[] | select(.name | test("acmg-class-by-freq.*\\.tar\\.gz$")) | .url' | tail -n 1)
wget -O $CLINVAR_JSONL_DIR/clinvar-data-acmg-class-by-freq.tar.gz $URL

URL=$(gh release view -R varfish-org/clinvar-data-jsonl --json assets   -q '.assets[] | select(.name | test("extract-vars.*\\.tar\\.gz$")) | .url' | tail -n 1)
wget -O $CLINVAR_JSONL_DIR/clinvar-data-extract-vars.tar.gz $URL

URL=$(gh release view -R varfish-org/clinvar-data-jsonl --json assets   -q '.assets[] | select(.name | test("gene-variant-report.*\\.tar\\.gz$")) | .url' | tail -n 1)
wget -O $CLINVAR_JSONL_DIR/clinvar-data-gene-variant-report.tar.gz $URL

URL=$(gh release view -R varfish-org/clinvar-data-jsonl --json assets   -q '.assets[] | select(.name | test("phenotype-links.*\\.tar\\.gz$")) | .url' | tail -n 1)
wget -O $CLINVAR_JSONL_DIR/clinvar-data-phenotype-links.tar.gz $URL

for f in $CLINVAR_JSONL_DIR/*.tar.gz; do
    tar -C $CLINVAR_JSONL_DIR -xzf $f
done

ls -lhR $CLINVAR_JSONL_DIR

df -h

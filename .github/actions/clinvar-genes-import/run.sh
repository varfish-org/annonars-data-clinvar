#!/usr/bin/bash

# Perform the annonars import

set -euo pipefail
set -x

mkdir -p $OUTPUT_DIR/clinvar-genes

# The transmogrification (tr/sed) can go away after the latest clinvar-this version is used...
export TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT ERR
for x in \
  $CLINVAR_JSONL_DIR/clinvar-data-extract-vars-*/clinvar-variants-grch3?-seqvars.jsonl.gz; do
    zcat $x \
    | tr "'" '"' \
    | sed -e 's/None/null/g' \
    | egrep '"benign"|"likely benign"|"uncertain significance"|"pathogenic"|"pathogenic"' \
    | egrep -v '"start": null|"stop": null' \
    > $TMPDIR/$(basename $x .gz)

    gzip -c $TMPDIR/$(basename $x .gz) > $x
done
for x in \
  $CLINVAR_JSONL_DIR/clinvar-data-gene-variant-report-*/gene-variant-report.jsonl.gz \
  $CLINVAR_JSONL_DIR/clinvar-data-acmg-class-by-freq-*/clinvar-acmg-class-by-freq.jsonl.gz; do
    zcat $x \
    | tr "'" '"' \
    | sed -e 's/None/null/g' \
    > $TMPDIR/$(basename $x .gz)

    gzip -c $TMPDIR/$(basename $x .gz) > $x
done

annonars clinvar-genes import \
    --path-per-impact-jsonl $CLINVAR_JSONL_DIR/clinvar-data-gene-variant-report-*/gene-variant-report.jsonl.gz \
    --path-per-frequency-jsonl $CLINVAR_JSONL_DIR/clinvar-data-acmg-class-by-freq-*/clinvar-acmg-class-by-freq.jsonl.gz \
    --paths-variant-jsonl $CLINVAR_JSONL_DIR/clinvar-data-extract-vars-*/clinvar-variants-grch37-seqvars.jsonl.gz \
    --paths-variant-jsonl $CLINVAR_JSONL_DIR/clinvar-data-extract-vars-*/clinvar-variants-grch38-seqvars.jsonl.gz \
    --path-out-rocksdb $OUTPUT_DIR/clinvar-genes/rocksdb

cat >$OUTPUT_DIR/clinvar-genes/spec.yaml <<EOF
dc.identifier: annonars/clinvar-genes-$CLINVAR_RELEASE+$ANNONARS_VERSION
dc.title: annonars ClinVar gene database
dc.creator: NCBI ClinVar Team
dc.contributor:
  - VarFish Development Team
dc.format: application/x-rocksdb
dc.date: $(date +%Y%m%d)
x-version: $CLINVAR_RELEASE+$ANNONARS_VERSION
dc.description: |
  RocksDB with per-gene information from ClinVar weekly release $CLINVAR_RELEASE,
  created from clinvar-data-jsonl output of this release and annonars
  v${ANNONARS_VERSION}.
dc.source:
  - PMID:29165669
  - https://github.com/bihealth/clinvar-data-jsonl
  - https://github.com/bihealth/annonars-data-clinvar
x-created-from:
  - name: ClinVar weekly release
    version: $CLINVAR_RELEASE
EOF

ls -lhR $OUTPUT_DIR
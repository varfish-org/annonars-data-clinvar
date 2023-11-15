#!/usr/bin/bash

# Perform the annonars import

set -euo pipefail
set -x

genome_release=$(echo $GENOME_RELEASE | tr '[:upper:]' '[:lower:]')

mkdir -p $OUTPUT_DIR/$genome_release/clinvar-minimal

# The transmogrification (tr/sed) can go away after the latest clinvar-this version is used...
export TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT ERR
for x in \
  $CLINVAR_JSONL_DIR/clinvar-data-extract-vars-*/clinvar-variants-$genome_release-seqvars.jsonl.gz; do
    zcat $x \
    | tr "'" '"' \
    | sed -e 's/None/null/g' \
    | egrep '"benign"|"likely benign"|"uncertain significance"|"likely pathogenic"|"pathogenic"' \
    | egrep -v '"start": null|"stop": null' \
    > $TMPDIR/$(basename $x .gz)

    gzip -c $TMPDIR/$(basename $x .gz) > $x
done

annonars clinvar-minimal import \
    --genome-release $genome_release \
    --path-in-jsonl $CLINVAR_JSONL_DIR/clinvar-data-extract-vars-*/clinvar-variants-$genome_release-seqvars.jsonl.gz \
    --path-out-rocksdb $OUTPUT_DIR/$genome_release/clinvar-minimal/rocksdb

cat >$OUTPUT_DIR/$genome_release/clinvar-minimal/spec.yaml <<EOF
dc.identifier: annonars/clinvar-$CLINVAR_RELEASE+$ANNONARS_VERSION
dc.title: annonars ClinVar minimal variant database
dc.creator: NCBI ClinVar Team
dc.contributor:
  - VarFish Development Team
dc.format: application/x-rocksdb
dc.date: $(date +%Y%m%d)
x-version: $CLINVAR_RELEASE+$ANNONARS_VERSION
x-genome-release: $genome_release
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
cat $OUTPUT_DIR/$genome_release/clinvar-minimal/spec.yaml

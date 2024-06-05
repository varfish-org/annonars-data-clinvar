#!/usr/bin/bash

# Perform the annonars import

set -euo pipefail
set -x

genome_release=$(echo $GENOME_RELEASE | tr '[:upper:]' '[:lower:]')

mkdir -p $OUTPUT_DIR/$genome_release/clinvar-sv

sudo docker run \
    --volume "$CLINVAR_JSONL_DIR:$CLINVAR_JSONL_DIR:ro" \
    --volume "$OUTPUT_DIR:$OUTPUT_DIR:rw" \
    ghcr.io/varfish-org/annonars:${ANNONARS_VERSION} \
    exec /usr/local/bin/annonars \
        clinvar-sv import \
        --genome-release $genome_release \
        --path-in-jsonl $CLINVAR_JSONL_DIR/clinvar-data-extract-vars-*/clinvar-variants-$genome_release-seqvars.jsonl.gz \
        --path-in-jsonl $CLINVAR_JSONL_DIR/clinvar-data-extract-vars-*/clinvar-variants-$genome_release-strucvars.jsonl.gz \
        --path-out-rocksdb $OUTPUT_DIR/$genome_release/clinvar-sv/rocksdb

cat >$OUTPUT_DIR/$genome_release/clinvar-sv/spec.yaml <<EOF
dc.identifier: annonars/clinvar-$CLINVAR_RELEASE+$ANNONARS_VERSION
dc.title: annonars ClinVar SV variant database
dc.creator: NCBI ClinVar Team
dc.contributor:
  - VarFish Development Team
dc.format: application/x-rocksdb
dc.date: $(date +%Y%m%d)
x-version: $CLINVAR_RELEASE+$ANNONARS_VERSION
x-genome-release: $genome_release
dc.description: |
  RocksDB with SV information from ClinVar weekly release $CLINVAR_RELEASE,
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
cat $OUTPUT_DIR/$genome_release/clinvar-sv/spec.yaml

cd $OUTPUT_DIR/$genome_release/clinvar-sv
hashdeep -l -r . >/tmp/MANIFEST.txt
CHECKSUM=$(sha256sum /tmp/MANIFEST.txt | cut -d ' ' -f 1)
echo "## EOF SHA256=$CHECKSUM" >> /tmp/MANIFEST.txt
cp /tmp/MANIFEST.txt .

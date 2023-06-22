#!/usr/bin/bash

set -euo pipefail
set -x

mkdir -p $REF_DIR

export TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT ERR

if [[ ! -e $REF_DIR/hs37d5.fa.fai ]]; then
    wget -O $TMPDIR/hs37d5.fa.gz \
        https://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
    (zcat --quiet $TMPDIR/hs37d5.fa.gz || true) \
    > $REF_DIR/hs37d5.fa
    samtools faidx $REF_DIR/hs37d5.fa
fi

if [[ ! -e $REF_DIR/GRCh38_no_alt_analysis_set.fa.fai ]]; then
    wget -O $TMPDIR/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz \
        https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz
    (zcat --quiet $TMPDIR/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz  || true) \
    > $REF_DIR/GRCh38_no_alt_analysis_set.fa
    samtools faidx $REF_DIR/GRCh38_no_alt_analysis_set.fa
fi
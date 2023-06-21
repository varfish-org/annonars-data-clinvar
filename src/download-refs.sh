#!/usr/bin/bash

set -euo pipefail
set -x

export REF=/var/local/annonars-data-clinvar/references
mkdir -p $REF

export TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT ERR

if [[ ! -e $REF/hs37d5.fa.fai ]]; then
    wget -O $TMPDIR/hs37d5.fa.gz \
        https://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
    (set +e; zcat --quiet $TMPDIR/hs37d5.fa.gz) \
    > $REF/hs37d5.fa
    samtools faidx $REF/hs37d5.fa
fi

if [[ ! -e $REF/GRCh38_no_alt_analysis_set.fa.fai ]]; then
    wget -O $TMPDIR/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz \
        https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz
    (set +e; zcat --quiet $TMPDIR/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz) \
    > $REF/GRCh38_no_alt_analysis_set.fa
    samtools faidx $REF/GRCh38_no_alt_analysis_set.fa
fi

#!/usr/bin/bash

set -euo pipefail

set -x

pushd /tmp
git clone https://github.com/bihealth/clinvar-tsv.git
cd clinvar-tsv
pip uninstall -y clinvar-tsv
pip install -e .
popd

export TMPDIR=$(mktemp -d)
cd $TMPDIR

checkout_dir=$PWD

echo "Download reference genomes and build FAI indices"

curl https://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz \
| gzip -d -c \
> $TMPDIR/hs37d5.fa
samtools faidx $TMPDIR/hs37d5.fa

curl ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz \
| gzip -d -c \
> $TMPDIR/GRCh38_no_alt_analysis_set.fa
samtools faidx $TMPDIR/GRCh38_no_alt_analysis_set.fa

echo "Run clinvar-tsv"

clinvar_tsv main \
    --b37-path $TMPDIR/hs37d5.fa \
    --b38-path $TMPDIR/GRCh38_no_alt_analysis_set.fa \
    --clinvar-version $(cat $checkout_dir/clinvar-release.txt || echo 2023-0617)

find .

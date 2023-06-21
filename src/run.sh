#!/usr/bin/bash

set -euo pipefail

set -x

df -h

sudo rm -rf /usr/share/dotnet
sudo rm -rf /opt/ghc
sudo rm -rf "/usr/local/share/boost"
sudo rm -rf "$AGENT_TOOLSDIRECTORY"

df -h

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

wget -O $TMPDIR/hs37d5.fa.gz \
    https://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
zcat --quiet $TMPDIR/hs37d5.fa.gz \
> $TMPDIR/hs37d5.fa
rm $TMPDIR/hs37d5.fa.gz
samtools faidx $TMPDIR/hs37d5.fa

wget -O $TMPDIR/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz \
    https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz
zcat --quiet $TMPDIR/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz \
> $TMPDIR/GRCh38_no_alt_analysis_set.fa
rm $TMPDIR/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz
samtools faidx $TMPDIR/GRCh38_no_alt_analysis_set.fa

echo "Run clinvar-tsv"

clinvar_tsv main \
    --b37-path $TMPDIR/hs37d5.fa \
    --b38-path $TMPDIR/GRCh38_no_alt_analysis_set.fa \
    --clinvar-version $(cat $checkout_dir/clinvar-release.txt || echo 2023-0617)

find .

#!/bin/bash

# RNA-seq ALS pipeline
# Step 05: Gene-level read counting with featureCounts

set -e

PROJECT="/mnt/d/rnaseq-als-pipeline"
ANNOTATION="$PROJECT/refs/annotation/gencode.v47.annotation.gtf"
OUTDIR="$PROJECT/results/counts"

mkdir -p "$OUTDIR"

featureCounts \
  -p \
  --countReadPairs \
  -B \
  -C \
  -T 4 \
  -t exon \
  -g gene_id \
  -a "$ANNOTATION" \
  -o "$OUTDIR/gene_counts_pe.txt" \
  "$PROJECT/data/bam/SRR22511818.sorted.bam" \
  "$PROJECT/data/bam/SRR22511830.sorted.bam" \
  "$PROJECT/data/bam/SRR22511910.sorted.bam" \
  "$PROJECT/data/bam/SRR22511922.sorted.bam"

echo "featureCounts completed successfully."

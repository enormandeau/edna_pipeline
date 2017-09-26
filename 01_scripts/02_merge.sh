#!/bin/bash

# Parameters
NCPUS=$1
MIN_OVERLAP=$2
MAX_OVERLAP=$3

# Global variables
TRIMMED_FOLDER="05_trimmed"
MERGED_FOLDER="06_merged"

# Parallelize on all trimmed files
ls -1 -S "$TRIMMED_FOLDER"/*_R1_*.fastq.gz |
    perl -pe 's/R[12].*\.fastq.gz//' |
    parallel -j "$NCPUS" flash -t 1 -z -O -m "$MIN_OVERLAP" -M "$MAX_OVERLAP" \
        {}R1_001.fastq.gz {}R2_001.fastq.gz \
        --to-stdout \> "$MERGED_FOLDER"/{/}merged.fastq.gz

#!/bin/bash
# Trim reads and remove
# - Reads with bad quality
# - Short reads

# Parameters
NCPUS=$1
MIN_HIT_LENGTH=$2

# Global variables
DATAFOLDER="04_data"

# Parallelize on all raw data files
ls -1 -S "$DATAFOLDER"/*_R1_*.fastq.gz |
    perl -pe 's/R[12].*gz//' |
    parallel -k -j "$NCPUS" ./01_scripts/util/trimmomatic.sh {} "$MIN_HIT_LENGTH"

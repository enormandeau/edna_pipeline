#!/bin/bash

# Parameters
SIMILARITY_VSEARCH=$1
MAX_ACCEPTS=$2
MAX_REJECTS=$3
QUERY_COV=$4
NCPUS=$5

# Global variables
INFO_FOLDER="02_info"
CHIMERA_FOLDER="08_chimeras"
VSEARCH_FOLDER="09_vsearch"

# Find best hit in database using vsearch
for amplicon in $(grep -v "^#" "$INFO_FOLDER"/primers.csv | awk -F "," '{print $1}')
do
    database=$(grep -v "^#" "$INFO_FOLDER"/primers.csv | grep $amplicon | awk -F "," '{print $6}').fasta.gz
    echo "#############################"
    echo "# Using database: $database"
    echo "#############################"

    # Treat each sample
    for sample in $(ls -1 "$CHIMERA_FOLDER"/*"$amplicon"*.fastq.gz)
    do
        # File names
        fastq=$(basename "$sample")
        fasta="${fastq%.fastq.gz}"_unique.fasta

        # Create fasta file
        echo
        ./01_scripts/util/fastq_to_unique_fasta.py "$CHIMERA_FOLDER"/"$fastq" "$CHIMERA_FOLDER"/"$fasta"

        # Run vsearch
        echo "Running vsearch on $fasta with database $database"
        vsearch --usearch_global "$CHIMERA_FOLDER"/"$fasta" -db 03_databases/"$database" \
            --threads "$NCPUS" --qmask none --dbmask none --id "$SIMILARITY_VSEARCH" \
            --blast6out "$VSEARCH_FOLDER"/"${fasta%.fasta}"."${database%.fasta.gz}" \
            --dbmatched "$VSEARCH_FOLDER"/"${fasta%.fasta}"."${database%.fasta.gz}_matched.fasta" \
            --maxaccepts "$MAX_ACCEPTS" --maxrejects "$MAX_REJECTS" --maxhits "$MAX_ACCEPTS" \
            --query_cov "$QUERY_COV" --fasta_width 0
    done
done

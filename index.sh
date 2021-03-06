#!/bin/bash

#########################################################
# 
# Platform: NCI Gadi HPC
# Description: create BAI index for the dedup/sort BAM file
# Usage: this script is executed by index_run_parallel.pbs
# Author: Cali Willet
# cali.willet@sydney.edu.au
# Date last modified: 24/07/2020
#
# If you use this script towards a publication, please acknowledge the
# Sydney Informatics Hub (or co-authorship, where appropriate).
#
# Suggested acknowledgement:
# The authors acknowledge the scientific and technical assistance 
# <or e.g. bioinformatics assistance of <PERSON>> of Sydney Informatics
# Hub and resources and services from the National Computational 
# Infrastructure (NCI), which is supported by the Australian Government
# with access facilitated by the University of Sydney.
# 
#########################################################


module load samtools/1.10

labSampleID=`echo $1 | cut -d ',' -f 1`
NCPUS=`echo $1 | cut -d ',' -f 2`

bam_out=./Dedup_sort/${labSampleID}.coordSorted.dedup.bam

samtools index -@ $NCPUS $bam_out


#!/bin/bash

#########################################################
# 
# Platform: NCI Gadi HPC
# Description: create input lists for merging recalibrated split 
# BAM files into a final BAM per sample
# Usage: bash bqsr_merge_make_input.sh <cohort_name>
# Details:
# 	Run tumour and normal as separate jobs re ~ double 
#	walltime for tumour. If no binomial grouping is required, 
#	change group=true to group=false. When group=true, assumes 
#	normal samples end with 'N' and all other phenotype IDs 
#	are assigned to tumour	
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

cohort=$1

group=true

t_input=./Inputs/bqsr_merge.inputs-tumour
n_input=./Inputs/bqsr_merge.inputs-normal
input=./Inputs/bqsr_merge.inputs

rm -f $t_input
rm -f $n_input
rm -f $input


awk 'NR>1' ${cohort}.config | while read CONFIG
do 
        labSampleID=`echo $CONFIG | cut -d ' ' -f 2`	
	
	if [[ $group = true ]]
	then
		if [[ $labSampleID = *-N ]]
       		then
			printf "${labSampleID}\n" >> $n_input
		else 
			printf "${labSampleID}\n" >> $t_input
		fi
	else
		printf "${labSampleID}\n" >> $input
	fi	
done 


if [ -f $input ]
then
        tasks=`wc -l < $input`
        printf "Number of BQSR merge tasks to run: ${tasks}\n"
fi

if [ -f $n_input ]
then
        tasks=`wc -l < $n_input`
        printf "Number of BQSR merge normal sample tasks to run: ${tasks}\n"
fi

if [ -f $t_input ]
then
        tasks=`wc -l < $t_input`
        printf "Number of BQSR merge tumour sample tasks to run: ${tasks}\n"
fi

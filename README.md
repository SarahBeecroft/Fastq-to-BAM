# Fastq-to-BAM
Optimised pipeline to process whole genome sequence data from fastq to BAM on NCI Gadi

22/7/20 - please note this pipeline is not yet fully published. This represents 5 out of a toal of 9 steps for this pipeline.

<img src="https://user-images.githubusercontent.com/49257820/87630794-4e7ce680-c779-11ea-9b79-ff22fdb379af.png" width="100%" height="100%">

# Description

Paired fastq files were split into smaller files of approximately 500,000 read pairs with fastp v. 0.20.0 (Chen et al. 2018) for parallel alignment. Reads were aligned to hg38 + alt contigs as downloaded by bwakit v. 0.7.17 ‘run-gen-ref’. Alignment was performed with BWA-MEM v. 0.7.17 (Li 2013), using the ‘M’ flag to mark split hits as secondary. Post-processing of the reads was performed with bwa-postalt.js from bwakit v. 0.7.17 to improve mapping quality of alt hits. During alignment, reads mapping to any of the six HLA genes were extracted to fastq format for later analysis. Scattered BAM files were merged into sample-level BAMs with SAMbamba v. 0.7.1 (Tarasov et al. 2015). Duplicate reads were marked with SAMblaster v. 0.1.24 (Faust and Hall 2014), then sorted by genomic coordinate and indexed with SAMtools v. 1.10 (Li et al. 2009). During duplicate read marking, split and discordant reads were extracted to BAM format for later analysis. Base quality score recalibration was performed with GATK v 4.1.2.0 (Van der Auwera et al. 2013). GATK SplitIntervals was used to define 32 evenly-sized genomic intervals over which GATK BaseRecalibrator was run for each sample. The 32 recalibration tables per sample were merged into one table per sample with GATK GatherReports. Base-recalibrated BAM files were produced with GATK ApplyBQSR in parallel over each of the 3,366 contigs in the hg 38 + alt reference genome, plus the unmapped reads. These were merged into a final BAM per sample with SAMbamba.

All computation was performed on NCI ‘Gadi’ HPC, running Centos 8, PBS Pro v. 19, on Intel Xeon Cascade Lake 2 x 24 core nodes each with 192 GB RAM. All stages of the analysis were run in parallel, either massively parallel using the scatter-gather method, or parallel by sample. Parallelisation across the cluster was achieved through either GNU parallel v. 20191022 (Tange 2018) or Open MPI v. 4.0.2 (Graham et al. 2005). 


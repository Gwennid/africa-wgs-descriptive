#This is template code for mapping paired-end FASTQ. The resulting BAM is then indexed.
#This was applied to the data generated in this study, as well as comparative SGDP and KGP data.

#Program version: picard/1.126, bwakit/0.7.12
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt
/sw/apps/bioinfo/bwakit/0.7.12/bwa.kit/seqtk mergepe input_1.fastq.gz input_2.fastq.gz \
	| /sw/apps/bioinfo/bwakit/0.7.12/bwa.kit/bwa mem -p -t4 -R'@RG\tID:sampleID_Llane\tSM:sampleID\tPL:ILLUMINA\tLB:lib1\tPU:Lane' ${reference_hg38} - 2> logfile \
	| /sw/apps/bioinfo/bwakit/0.7.12/bwa.kit/k8 /sw/apps/bioinfo/bwakit/0.7.12/bwa.kit/bwa-postalt.js -p sampleID_Llane.hla /proj/b2012165/nobackup/private/Seq_project_cont/reference_hg38/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt \
	| java -Xmx7g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar SortSam INPUT=/dev/stdin OUTPUT=sampleID_Llane_sorted.bam SORT_ORDER=coordinate
java -Xmx7g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar BuildBamIndex INPUT=sampleID_Llane_sorted.bam

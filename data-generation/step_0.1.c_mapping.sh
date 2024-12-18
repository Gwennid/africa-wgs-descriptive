#This is template code for extracting relevant reads from a BAM file and proceeding with mapping. The resulting BAM is then indexed.
#This was applied to the data from Schlebusch et al. 2020.

#Extract the reads that did not involve whole-genome amplification:
#Program version: samtools/1.1
/pica/sw/apps/bioinfo/samtools/1.1/milou/bin/samtools view -b -r readgroup -o sampleID_RG1.genomic.bam sampleID.bam

#Shuffle and revert the BAM to a FASTQ:
#Program version: samtools/1.1
IN=sampleID_RG1.genomic.bam
F=sampleID_RG1.genomic.fastq #interleaved FASTQ
samtools bamshuf -Ou "${IN}" $SNIC_TMP/shuf.bam | samtools bam2fq /dev/stdin > $SNIC_TMP/"${F}"
mv $SNIC_TMP/* .
gzip ${F}

#Mapping
#Program version: picard/1.126, bwakit/0.7.12
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt
cat input.fastq.gz \
	| /sw/apps/bioinfo/bwakit/0.7.12/bwa.kit/bwa mem -p -t4 -R'@RG\tID:sampleID_Llane\tSM:sampleID\tPL:ILLUMINA\tLB:lib1\tPU:Lane' ${reference_hg38} - 2> logfile \
	| /sw/apps/bioinfo/bwakit/0.7.12/bwa.kit/k8 /sw/apps/bioinfo/bwakit/0.7.12/bwa.kit/bwa-postalt.js -p sampleID_Llane.hla /proj/b2012165/nobackup/private/Seq_project_cont/reference_hg38/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt \
	| java -Xmx7g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar SortSam INPUT=/dev/stdin OUTPUT=sampleID_Llane_sorted.bam SORT_ORDER=coordinate
java -Xmx7g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar BuildBamIndex INPUT=sampleID_Llane_sorted.bam

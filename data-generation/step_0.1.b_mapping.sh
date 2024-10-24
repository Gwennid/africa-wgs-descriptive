#This is template code for mapping when the input data is mapped BAM. The mapped BAM is reverted to unmapped and shuffled prior to mapping.
#The resulting BAM is then indexed. This was applied to comparative "SGDP letter", HGDP, and SAHGP data.

#Revert mapped BAM to unmapped BAM
#Program version: picard/1.126
java -Xmx28g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar RevertSam VALIDATION_STRINGENCY=LENIENT I=${infolder}/${infile}.bam O=${infile}.revertsam.bam SANITIZE=true MAX_DISCARD_FRACTION=0.005 ATTRIBUTE_TO_CLEAR=BC ATTRIBUTE_TO_CLEAR=XD ATTRIBUTE_TO_CLEAR=AM ATTRIBUTE_TO_CLEAR=SM ATTRIBUTE_TO_CLEAR=H0 ATTRIBUTE_TO_CLEAR=H1 ATTRIBUTE_TO_CLEAR=H2 ATTRIBUTE_TO_CLEAR=XC SORT_ORDER=queryname RESTORE_ORIGINAL_QUALITIES=true REMOVE_DUPLICATE_INFORMATION=true REMOVE_ALIGNMENT_INFORMATION=true

#Shuffle BAM, revert to FASTQ, and map
#Program version: samtools/1.1, picard/1.126, bwakit/0.7.12
samtools bamshuf -Ou "${IN}" $SNIC_TMP/shuf.bam | \
samtools bam2fq /dev/stdin | /sw/apps/bioinfo/bwakit/0.7.12/bwa.kit/bwa mem -t4 -p -R'@RG\tID:HGDPID\tSM:HGDP_INFILE\tPL:ILLUMINA\tLB:lib1\tPU:Lane' /proj/b2012165/nobackup/private/Seq_project_cont/reference_hg38/GRCh38_full_analysis_set_plus_decoy_hla.fa - 2> HGDPid.log.bwamem \
  | /sw/apps/bioinfo/bwakit/0.7.12/bwa.kit/k8 /sw/apps/bioinfo/bwakit/0.7.12/bwa.kit/bwa-postalt.js -p HGDPID.hla /proj/b2012165/nobackup/private/Seq_project_cont/reference_hg38/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt \
  | java -Xmx28g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar SortSam INPUT=/dev/stdin OUTPUT=HGDPID_sorted.bam SORT_ORDER=coordinate
java -Xmx28g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar BuildBamIndex INPUT=HGDPID_sorted.bam

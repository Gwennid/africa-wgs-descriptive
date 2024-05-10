#This is template code for merging the recalibrated lanes belonging to a sample and sorting them.

#Input: output of step_A.6_triple-mask-BQSR.sh (several recalibrated BAM)
#Output: a recalibrated BAM (one per sample)

#Program version: samtools/1.1, picard/1.126, vcftools/0.1.13

# Merge bam
ls BQSR/recal_3mask/sampleID_L*.dedup.realn.3mask_recal.1-22X.bam > BQSR/recal_3mask/bam_list_sampleID
samtools merge BQSR/recal_3mask/sampleID_merge.dedup.realn.3mask_recal.1-22X.bam -b BQSR/recal_3mask/bam_list_sampleID

# Sort by coordinates and index
java -Xmx14g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar SortSam \
	INPUT=BQSR/recal_3mask/sampleID_merge.dedup.realn.3mask_recal.1-22X.bam \
	OUTPUT=BQSR/recal_3mask/sampleID_merge.3mask_recal.1-22X.sorted.bam \
	SORT_ORDER=coordinate \
	CREATE_INDEX=true

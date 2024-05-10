#This is template code for realigning around indel (sample level).

#Input: output of step_A.8_mark-duplicates.sh (recalibrated BAM with duplicates marked)
#Output: a recalibrated, duplicates marked, and realigned around indels BAM

# Program version: GATK/3.5.0

reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

# Step 1: identify spots that need to be realigned
java -Xmx7g -jar $GATK_HOME/GenomeAnalysisTK.jar -T RealignerTargetCreator \
	-R ${reference_hg38} \
	-I marked_duplicates_bam/dedup_persample/sampleID_merge.3mask_recal.1-22X.sorted.dedup.bam \
	-o indels_realignment_targets/targets_persample/sampleID_realignment_targets.list \
	-L interval_lists/chr_random_Un_nochrY_nochrM.intervals

# Step 2: realign
java -Xmx7g -jar $GATK_HOME/GenomeAnalysisTK.jar -T IndelRealigner \
	-R ${reference_hg38} \
	-I marked_duplicates_bam/dedup_persample/sampleID_merge.3mask_recal.1-22X.sorted.dedup.bam \
	-targetIntervals indels_realignment_targets/targets_persample/sampleID_realignment_targets.list \
	-o indels_realigned_bam/realigned_persample/sampleID_merge.3mask_recal.1-22X.dedup.realn.bam \
	-L interval_lists/chr_random_Un_nochrY_nochrM.intervals

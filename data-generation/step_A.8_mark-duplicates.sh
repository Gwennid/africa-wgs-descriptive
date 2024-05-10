# This is template code for marking duplicate reads.

#Program version: picard/1.126
#Input: output of step_A.7_merge-and-sort.sh
#Output: marked duplicates BAM (one per sample)

java -Xmx7g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar MarkDuplicates \
  INPUT=BQSR/recal_3mask/sampleID_merge.3mask_recal.1-22X.sorted.bam \
  OUTPUT=marked_duplicates_bam/dedup_persample/sampleID_merge.3mask_recal.1-22X.sorted.dedup.bam \
  METRICS_FILE=marked_duplicates_bam/dedup_persample/sampleID_metrics.txt \
  CREATE_INDEX=true

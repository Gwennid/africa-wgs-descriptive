# This is template code for marking duplicate reads.

#Program version: picard/1.126
#Input: output of step_0.2_split-mapped-unmapped.sh, "output_sorted_mapped.bam" (indexed BAM)
java -Xmx7g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar MarkDuplicates \ INPUT=output_sorted_mapped.bam \ OUTPUT=marked_duplicates_bam/dedup_perlane/sampleID_Llane.dedup.bam \ METRICS_FILE=marked_duplicates_bam/dedup_perlane/sampleID_Llane_metrics.txt \ CREATE_INDEX=true

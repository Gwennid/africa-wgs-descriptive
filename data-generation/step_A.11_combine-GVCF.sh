# This is template code for combining single sample GVCF into multi-sample GVCF.
# It is run by chromosome.

# Input: output of step_A.10_variant-calling.sh -single sample GVCF- for a number of samples (49 RHG; 25 KS + SAHGP samples; remaining comparative samples)
# Output: a multi-sample GVCF file

# Program version: GATK/3.7
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

java -Xmx6g -jar /sw/apps/bioinfo/GATK/3.7/GenomeAnalysisTK.jar -T CombineGVCFs \
-R ${reference_hg38} \
-V sample1_merge.3mask_recal.1-22X.dedup.realn_${CHR}.g.vcf.gz \
-V sample2_merge.3mask_recal.1-22X.dedup.realn_${CHR}.g.vcf.gz \
-V sample3_merge.3mask_recal.1-22X.dedup.realn_${CHR}.g.vcf.gz \
[…] \
-G Standard -G AS_Standard \
-o 49RHG.${CHR}.g.vcf.gz

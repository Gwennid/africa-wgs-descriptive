#This is template code for combining single sample GVCF into multi-sample GVCF.

#Input: output of step_X.1_variant-calling.sh -single sample GVCF- for the 179 samples.
#Output: a multi-sample GVCF file

# Program version: GATK/3.7, tabix/0.2.6
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

java -Xmx18g -jar /sw/apps/bioinfo/GATK/3.7/GenomeAnalysisTK.jar -T CombineGVCFs \
-R ${reference_hg38} \
-V sample1_HC_AS_X.g.vcf.gz \
-V sample2_HC_AS_X.g.vcf.gz \
[...] \
-V sample179_HC_AS_X.g.vcf.gz \
-G Standard -G AS_Standard \
-o alldatacomb.X.179ind.g.vcf.gz

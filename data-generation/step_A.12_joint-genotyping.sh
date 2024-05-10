# This is template code for joint genotyping the entire callset.
# It is run by chromosome.

# Input: output of step_A.11_combine-GVCF.sh - a multi-sample GVCF file
# Output: a multi-sample VCF file

# Program version: GATK/3.7
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

java -Xmx12g -jar /sw/apps/bioinfo/GATK/3.7/GenomeAnalysisTK.jar -T GenotypeGVCFs \
-R ${reference_hg38} \
--dbsnp ${dbsnp} \
-L chr${CHR} \
-allSites \
-V 25KS.24SAHGP.${CHR}.g.vcf.gz \
-V 49RHG.${CHR}.g.vcf.gz \
-V 81comp.${CHR}.g.vcf.gz \
-G Standard -G AS_Standard \
-o 25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.combinedGVCF.${CHR}.vcf.gz

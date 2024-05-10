#This is template code for joint genotyping the entire callset for chromosome X.

#Input: output of step_X.2_combine-GVCF.sh
#Ouput: a multi-sample VCF file

# Program version: GATK/3.7
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

java -Xmx11g -jar /sw/apps/bioinfo/GATK/3.7/GenomeAnalysisTK.jar -T GenotypeGVCFs \
-R ${reference_hg38} \
--dbsnp ${dbsnp} \
-L chrX \
-allSites \
-V alldatacomb.X.179ind.g.vcf.gz \
-G Standard -G AS_Standard \
-o ALLDATA_X_JG.179ind.vcf.gz

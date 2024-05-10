#This is template code for performing indel VQSR.
#The 22 autosomes are used to build the model; the recalibration is then applied to the separate VCF files.
#We used the recommended tranche threshold for human data.

#Input: output of step_A.13_SNP-VQSR.sh (SNP VQSRed multi-sample VCF)
#Output: SNP & indels VQSRed multi-sample VCF

#Program version: GATK/3.7
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

# Step 1: Variant Recalibrator
mills=/hg38bundle/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
inroot=25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.combinedGVCF

java -Xmx24g -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T VariantRecalibrator \
	-R ${reference_hg38} \
	-input ${inroot}.1.recalSNP99.9.vcf.gz \
	-input ${inroot}.2.recalSNP99.9vcf.gz \
	[...]
	-input ${inroot}.22.recalSNP99.9.vcf.gz \
	-resource:mills,known=false,training=true,truth=true,prior=12.0 $mills \
	-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 ${dbsnp151} \
	-an DP \
	-an QD \
	-an FS \
	-an SOR \
	-an MQRankSum \
	-an ReadPosRankSum \
	-an MQ \
	-mode INDEL \
	-tranche 100.0 -tranche 99.95 -tranche 99.94 -tranche 99.93 -tranche 99.92 -tranche 99.91 -tranche 99.9 -tranche 99.0 -tranche 95.0 -tranche 90.0 \
	-recalFile ${out}.recal \
	-tranchesFile ${out}.tranches \
	-nt 4

# Step 2: Apply recalibration
for CHR in {1..22}; do
java -Xmx18g -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T ApplyRecalibration \
	-R ${reference_hg38} \
	-input $inroot.${CHR}.recalSNP99.9.vcf.gz \
	-mode INDEL \
	--ts_filter_level 99.0 \
	-recalFile ${out}.recal \
	-tranchesFile ${out}.tranches \
	-o ${inroot}.${CHR}.recalSNP99.9.recalindel99.0.vcf.gz \
	-nt 3 \
	-L chr${CHR}
done

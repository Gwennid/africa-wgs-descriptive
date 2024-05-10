#This is template code for performing SNP VQSR.
#The 22 autosomes are used to build the model; the recalibration is then applied to the separate VCF files.
#We used the recommended tranche threshold for human data.

#Input: output of step_A.12_joint-genotyping.sh (multi-sample VCF)
#Output: VQSRed multi-sample VCF

#Program version: GATK/3.7
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

# Step 1: Variant Recalibrator
hapmap=/hg38bundle/hapmap_3.3.hg38.vcf.gz
omni=/hg38bundle/1000G_omni2.5.hg38.vcf.gz
tusenG=/hg38bundle/1000G_phase1.snps.high_confidence.hg38.vcf.gz
inroot=25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.combinedGVCF

java -Xmx24g -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T VariantRecalibrator \
	-R ${reference_hg38} \
	-input ${inroot}.1.vcf.gz \
	-input ${inroot}.2.vcf.gz \
	[...]
	-input ${inroot}.22.vcf.gz \
	-resource:hapmap,known=false,training=true,truth=true,prior=15.0 ${hapmap} \
	-resource:omni,known=false,training=true,truth=true,prior=12.0 ${omni} \
	-resource:1000G,known=false,training=true,truth=false,prior=10.0 ${tusenG} \
	-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 ${dbsnp151} \
	-an DP \
	-an QD \
	-an FS \
	-an SOR \
	-an MQRankSum \
	-an ReadPosRankSum \
	-an MQ \
	-mode SNP \
	-tranche 100.0 -tranche 99.95 -tranche 99.94 -tranche 99.93 -tranche 99.92 -tranche 99.91 -tranche 99.9 -tranche 99.0 -tranche 95.0 -tranche 90.0 \
	-recalFile ${out}.recal \
	-tranchesFile ${out}.tranches \
	-nt 4

# Step 2: Apply recalibration
for CHR in {1..22}; do
java -Xmx18g -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T ApplyRecalibration \
	-R ${reference_hg38} \
	-input $inroot.${CHR}.vcf.gz \
	-mode SNP \
	--ts_filter_level 99.9 \
	-recalFile ${out}.recal \
	-tranchesFile ${out}.tranches \
	-o ${inroot}.${CHR}.recalSNP99.9.vcf.gz \
	-nt 3 \
	-L chr${CHR}
done

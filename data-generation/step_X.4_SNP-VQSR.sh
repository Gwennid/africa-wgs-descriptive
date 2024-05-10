#This is template code for performing SNP VQSR on chromosome X.
#Chromosome X and the 22 autosomes are used to build the model; the recalibration is then applied to chromosome X only.
#We used the recommended tranche threshold for human data.

#Input:
## VariantRecalibrator: outputs of step_A.12_joint-genotyping.sh and step_X.3_joint-genotyping.sh (multi-sample VCF)
## ApplyRecalibration: output of step_X.3_joint-genotyping.sh
#Output: VQSRed multi-sample VCF

#Program version: GATK/3.7
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

inroot=25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.combinedGVCF

# Step 1: Variant Recalibrator
hapmap=/hg38bundle/hapmap_3.3.hg38.vcf.gz
omni=/hg38bundle/1000G_omni2.5.hg38.vcf.gz
tusenG=/hg38bundle/1000G_phase1.snps.high_confidence.hg38.vcf.gz
dbsnp=/dbsnp151/human_9606_b151_GRCh38p7/00-All.newchrnames.db151.vcf.gz
out=25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.1-22X.recalSNP

java -Xmx24g -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T VariantRecalibrator \
	-R ${reference_hg38} \
	-input ${inroot}.1.vcf.gz \
	-input ${inroot}.2.vcf.gz \
	-input ${inroot}.3.vcf.gz \
	-input ${inroot}.4.vcf.gz \
	-input ${inroot}.5.vcf.gz \
	-input ${inroot}.6.vcf.gz \
	-input ${inroot}.7.vcf.gz \
	-input ${inroot}.8.vcf.gz \
	-input ${inroot}.9.vcf.gz \
	-input ${inroot}.10.vcf.gz \
	-input ${inroot}.11.vcf.gz \
	-input ${inroot}.12.vcf.gz \
	-input ${inroot}.13.vcf.gz \
	-input ${inroot}.14.vcf.gz \
	-input ${inroot}.15.vcf.gz \
	-input ${inroot}.16.vcf.gz \
	-input ${inroot}.17.vcf.gz \
	-input ${inroot}.18.vcf.gz \
	-input ${inroot}.19.vcf.gz \
	-input ${inroot}.20.vcf.gz \
	-input ${inroot}.21.vcf.gz \
	-input ${inroot}.22.vcf.gz \
	-input ALLDATA_X_JG.179ind.vcf.gz \
	-resource:hapmap,known=false,training=true,truth=true,prior=15.0 $hapmap \
	-resource:omni,known=false,training=true,truth=true,prior=12.0 $omni \
	-resource:1000G,known=false,training=true,truth=false,prior=10.0 ${tusenG} \
	-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $dbsnp \
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
input=ALLDATA_X_JG.179ind.vcf.gz
tranche=99.9
output=ALLDATA_X_JG.179ind.recalSNP${tranche}.vcf.gz

java -Xmx6g -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T ApplyRecalibration \
	-R ${reference_hg38} \
	-input $input \
	-mode SNP \
	--ts_filter_level $tranche \
	-recalFile $out.recal \
	-tranchesFile $out.tranches \
	-o $output \
	-nt 1 \
	-L chrX

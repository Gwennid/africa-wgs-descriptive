#This is template code for performing indel VQSR on chromosome X.
#Chromosome X and the 22 autosomes are used to build the model; the recalibration is then applied to chromosome X only.
#We used the recommended tranche threshold for human data.

#Input:
## VariantRecalibrator: outputs of step_A.13_SNP-VQSR.sh and step_X.4_SNP-VQSR.sh (SNP VQSRed multi-sample VCF)
## ApplyRecalibration: output of step_X.4_SNP-VQSR.sh
#Output: SNP & indels VQSRed multi-sample VCF

#Program version: GATK/3.7
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

inroot=25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites
tranche=99.9
out=25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.1-22X.recalSNP${tranche}.recalINDEL

# Step 1: Variant Recalibrator
mills=/hg38bundle/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
dbsnp=/dbsnp151/human_9606_b151_GRCh38p7/00-All.newchrnames.db151.vcf.gz

java -Xmx24g -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T VariantRecalibrator \
	-R ${reference_hg38} \
	-input ${inroot}.1.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.2.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.3.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.4.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.5.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.6.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.7.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.8.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.9.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.10.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.11.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.12.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.13.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.14.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.15.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.16.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.17.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.18.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.19.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.20.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.21.recalSNP${tranche}.vcf.gz \
	-input ${inroot}.22.recalSNP${tranche}.vcf.gz \
	-input ALLDATA_X_JG.179ind.recalSNP${tranche}.vcf.gz \
	-resource:mills,known=false,training=true,truth=true,prior=12.0 $mills \
	-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $dbsnp \
	-an DP \
	-an QD \
	-an FS \
	-an SOR \
	-an MQRankSum \
	-an ReadPosRankSum \
	-mode INDEL \
	-tranche 100.0 -tranche 99.95 -tranche 99.94 -tranche 99.93 -tranche 99.92 -tranche 99.91 -tranche 99.9 -tranche 99.0 -tranche 95.0 -tranche 90.0 \
	-recalFile ${out}.recal \
	-tranchesFile ${out}.tranches \
	-nt 4

# Step 2: Apply recalibration
trancheindel=99.0
input=ALLDATA_X_JG.179ind.recalSNP${tranche}.vcf.gz
out=25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.1-22X.recalSNP${tranche}.recalINDEL
output=ALLDATA_X_JG.179ind.recalSNP${tranche}.recalINDEL${trancheindel}.vcf.gz

java -Xmx6g -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T ApplyRecalibration \
	-R ${reference_hg38} \
	-input $input \
	-mode INDEL \
	--ts_filter_level ${trancheindel} \
	-recalFile $out.recal \
	-tranchesFile $out.tranches \
	-o $output \
	-nt 1 \
	-L chrX

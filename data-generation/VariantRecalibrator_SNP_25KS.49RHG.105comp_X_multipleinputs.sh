#!/bin/bash -l
#SBATCH -J VariantRecalibrator_SNP_25KS.49RHG.105comp_X
#SBATCH -o VariantRecalibrator_SNP_25KS.49RHG.105comp_X.output
#SBATCH -e VariantRecalibrator_SNP_25KS.49RHG.105comp_X.output
# Default in slurm
#SBATCH --mail-user gwenna.breton@ebc.uu.se
#SBATCH --mail-type=FAIL,END
# Request 48 hours run time
#SBATCH -t 48:0:0
#SBATCH -A snic2018-8-397
#
#SBATCH -p core -n 4
# NOTE: You must not use more than 6GB of memory

module load bioinfo-tools GATK/3.7

cd /proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/VQSR

ref=/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/reference_hg38/GRCh38_full_analysis_set_plus_decoy_hla.fa
inroot=/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.combinedGVCF

hapmap=/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/GATK_resource_bundle/b38/hg38bundle/hapmap_3.3.hg38.vcf.gz
omni=/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/GATK_resource_bundle/b38/hg38bundle/1000G_omni2.5.hg38.vcf.gz
tusenG=/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/GATK_resource_bundle/b38/hg38bundle/1000G_phase1.snps.high_confidence.hg38.vcf.gz
dbsnp=/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp151/human_9606_b151_GRCh38p7/00-All.newchrnames.db151.vcf.gz
out=/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/VQSR/25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.1-22X.recalSNP

java -Xmx24g -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T VariantRecalibrator \
	-R $ref \
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
	-input /proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/VariantCalling/ALLDATA_X_JG.20190808.179ind.vcf.gz \
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

#Submit ApplyRecalibration
cd /proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/VQSR
sbatch ApplyRecalibration_SNP_25KS.49RHG.105comp_X.sh

#QUESTION: Does it make sense to use the 1-22 that were SNP recalibrated independently from the X for the INDEL VQSR? (I think it should be fine and plan to do it that way, but perhaps it is not the best).
#Why didn't I perform indel VQSR back then?






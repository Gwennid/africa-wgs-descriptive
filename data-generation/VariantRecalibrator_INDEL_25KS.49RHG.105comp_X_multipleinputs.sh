#!/bin/bash -l
#SBATCH -J VariantRecalibrator_INDEL_25KS.49RHG.105comp_X
#SBATCH -o VariantRecalibrator_INDEL_25KS.49RHG.105comp_X.output
#SBATCH -e VariantRecalibrator_INDEL_25KS.49RHG.105comp_X.output
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

tranche=99.9
inroot=/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/2_VQSR/25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites
mills=/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/GATK_resource_bundle/b38/hg38bundle/Mills_and_1000G_gold_standard.indels.hg38.vcf.gz
dbsnp=/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp151/human_9606_b151_GRCh38p7/00-All.newchrnames.db151.vcf.gz
out=/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/VQSR/25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.1-22X.recalSNP${tranche}.recalINDEL

java -Xmx24g -jar $GATK_HOME/GenomeAnalysisTK.jar \
	-T VariantRecalibrator \
	-R $ref \
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
	-input /proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/VariantCalling/ALLDATA_X_JG.20190808.179ind.recalSNP${tranche}.vcf.gz \
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

#Submit ApplyRecalibration
cd /proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/VQSR
sbatch ApplyRecalibration_INDEL_25KS.49RHG.105comp_X.sh






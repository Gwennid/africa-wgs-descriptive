#!/bin/bash -l
#SBATCH -J GenotypeGVCFs_X_ALLDATA
#SBATCH -o GenotypeGVCFs_X_ALLDATA.output
#SBATCH -e GenotypeGVCFs_X_ALLDATA.output
#SBATCH --mail-user gwenna.breton@ebc.uu.se
#SBATCH --mail-type=END,FAIL
#SBATCH -t 72:0:0
#SBATCH -A snic2019-3-12
#SBATCH -p core -n 2

module load bioinfo-tools
module load GATK/3.7
module load tabix/0.2.6

cd /proj/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/VariantCalling/

java -Xmx11g -jar /sw/apps/bioinfo/GATK/3.7/GenomeAnalysisTK.jar -T GenotypeGVCFs \
-R /proj/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/reference_hg38/GRCh38_full_analysis_set_plus_decoy_hla.fa \
--dbsnp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp144/00_all_newchrnames.vcf.gz \
-L chrX \
-allSites \
-V /proj/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/VariantCalling/alldatacomb.X.20190808.179ind.g.vcf.gz \
-G Standard -G AS_Standard \
-o /proj/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/VariantCalling/ALLDATA_X_JG.20190808.179ind.vcf.gz

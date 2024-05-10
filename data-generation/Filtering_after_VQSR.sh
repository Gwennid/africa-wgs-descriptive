#!/bin/bash -l
# NOTE the -l flag!
#SBATCH -J filter_chrom
#SBATCH -o filter_chrom.output
#SBATCH -e filter_chrom.output
# Default in slurm
#SBATCH --mail-user gwenna.breton@ebc.uu.se
#SBATCH --mail-type=FAIL,END
# Request 240 hours run time
#SBATCH -t 240:0:0
#SBATCH -A snic2018-8-397
#
#SBATCH -p core -n 1
# NOTE: You must not use more than 6GB of memory

###Gwenna Breton
###20190509
###Goal: this script runs after ApplyRecalibration_INDEL_25KS.49RHG.105comp_chr.sh Only the first step of ApplyRecalibration_INDEL is kept (I deleted the other outputs).
###Updated on 20191018 because it needs to be rerunned. In particular, added option -trimAlternates to the first SelectVariants step.

# STEP1: relatedness filtering (GATK)
module load bioinfo-tools GATK/3.7
module load bioinfo-tools tabix/0.2.6
module load bioinfo-tools vcftools/0.1.13

cd /proj/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/

in=/proj/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/2_VQSR/25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.chrom.recalSNP99.9.recalINDEL99.0.vcf
out_r=/proj/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/25KS.48RHG.104comp.HCBP.chrom.recalSNP99.9.recalINDEL99.0
ref=/proj/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/reference_hg38/GRCh38_full_analysis_set_plus_decoy_hla.fa

java -Xmx6g -jar $GATK_HOME/GenomeAnalysisTK.jar -T SelectVariants --variant ${in}.gz -R ${ref} -xl_sn PNP061 -xl_sn SGDP_LP6005441-DNA_B11 -L chrchrom -trimAlternates --out ${out_r}.vcf.gz

cd /proj/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering

# STEP2: calculate missingness and test for HWE (vcftools)
vcftools --gzvcf ${out_r}.vcf.gz --missing-site --out ${out_r}.vcf.gz
vcftools --gzvcf ${out_r}.vcf.gz --hardy --out ${out_r}.vcf.gz

# STEP3: change the FILTER status of sites with a N in the reference (to FAIL1_N), then of sites which have more than 10 % missingness (to FAIL2_M) and finally of sites which are heterozygous in all samples (to FAIL3_N). The filters are applied sequentially and a site has a single FILTER value (so some sites with a VQSR or a LowQual filter maybe fail missingness or HWE as well, but they won't get that filter). Non-variant sites can also get a FILTER value (instead of a .).
awk '$6 > 0.1 {print $2}' ${out_r}.vcf.gz.lmiss > fail_geno0.1_chrom
awk '$3 == "0/177/0" {print $2}'  ${out_r}.vcf.gz.hwe > fail_het177_chrom
gunzip ${out_r}.vcf.gz
awk 'BEGIN { OFS="\t" } $4 == "N" {sub("\\.", "FAIL1_N", $7)} {print $0}' ${out_r}.vcf | awk 'BEGIN { OFS="\t" } FNR==NR{a[$1];next}  ($2 in a) {sub(/PASS/, "FAIL2_M", $7); sub("^\\.$", "FAIL2_M", $7)} {print $0}' fail_geno0.1_chrom - > ${out_r}.FAIL1FAIL2.vcf

awk 'BEGIN { OFS="\t" } FNR==NR{a[$1];next}  ($2 in a) {sub(/PASS/, "FAIL3_H", $7); sub("^\\.$", "FAIL3_H", $7)} {print $0}' fail_het177_chrom ${out_r}.FAIL1FAIL2.vcf > ${out_r}.FAIL1FAIL2FAIL3.vcf

# STEP4: add relevant information about the three filtering steps to the header and compress

##The information was already saved in a text file called extra_filter
#echo "##FILTER=<ID=FAIL1_N,Description=\"Sites where there is a N in the reference genome (hg38) and previously had FILTER '.'\"> " > extra_filter
#echo "##FILTER=<ID=FAIL2_M,Description=\"Sites genotyped in less than 90% of the samples. Missingness calculated with vcftools --missing-site\"> " >> extra_filter
#echo "##FILTER=<ID=FAIL3_H,Description=\"Sites heterozygous in the 177 samples. HWE calculated with vcftools --hardy\"> " >> extra_filter

CHROM=chrom
numm=$(grep -n -m1 "#CHROM" ${out_r}.FAIL1FAIL2FAIL3.vcf | cut -d":" -f1)
head -$numm ${out_r}.FAIL1FAIL2FAIL3.vcf > header_${CHROM}
head -18 header_${CHROM} > 1header_${CHROM} #keep very first lines and all lines with "FILTER" descriptions
let numms=$numm-18
tail -${numms} header_${CHROM} > 2header_${CHROM}
cat 1header_${CHROM} extra_filter 2header_${CHROM} > new_header_${CHROM}
let numbb=$numm+1
tail -n +${numbb} ${out_r}.FAIL1FAIL2FAIL3.vcf > bott_${CHROM}
cat new_header_${CHROM} bott_${CHROM} > ${out_r}.FAIL1FAIL2FAIL3.reheaded.vcf
rm header_${CHROM}; rm 1header_${CHROM}; rm 2header_${CHROM}; rm bott_${CHROM}; rm new_header_${CHROM}

bgzip -f ${out_r}.FAIL1FAIL2FAIL3.reheaded.vcf
tabix -f ${out_r}.FAIL1FAIL2FAIL3.reheaded.vcf.gz

#TODO manually intermediate VCF files if everything looks good.
#Next script is: initial_analyses.sh

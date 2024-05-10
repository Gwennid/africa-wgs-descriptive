#This is template code for filtering of the autosomes after SNP and indels VQSR.
#It is run by chromosome.

#Input: output of step_A.14_indel-VQSR.sh (multi-sample, VQSRed VCF, 179 samples)
#Output: multi-sample VCF (177 samples) with additional filtering status

#Program version: GATK/3.7, tabix/0.2.6, vcftools/0.1.13
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

# Relatedness filtering
in=25KS.49RHG.105comp.HCBPresolution.GenotypeGVCFsallsites.combinedGVCF.${CHR}.recalSNP99.9.recalindel99.0.vcf
out_r=25KS.48RHG.104comp.HCBP.${CHR}.recalSNP99.9.recalINDEL99.0

java -Xmx6g -jar $GATK_HOME/GenomeAnalysisTK.jar -T SelectVariants --variant ${in}.gz -R ${reference_hg38} -xl_sn PNP061 -xl_sn SGDP_LP6005441-DNA_B11 -L chr${CHR} -trimAlternates --out ${out_r}.vcf.gz

# Calculate missingness and test for HWE (vcftools)
vcftools --gzvcf ${out_r}.vcf.gz --missing-site --out ${out_r}.vcf.gz
vcftools --gzvcf ${out_r}.vcf.gz --hardy --out ${out_r}.vcf.gz

# Change the FILTER status of sites with a N in the reference (to FAIL1_N);
#of sites which have more than 10 % missingness (to FAIL2_M);
#and of sites which are heterozygous in all samples (to FAIL3_N).
#The filters are applied sequentially and a site has a single FILTER value (so some sites with a VQSR or a LowQual filter maybe fail missingness or HWE as well, but they won't get that filter).
#Non-variant sites can also get a FILTER value (instead of a .).

awk '$6 > 0.1 {print $2}' ${out_r}.vcf.gz.lmiss > fail_geno0.1_${CHR}
awk '$3 == "0/177/0" {print $2}'  ${out_r}.vcf.gz.hwe > fail_het177_${CHR}
gunzip ${out_r}.vcf.gz
awk 'BEGIN { OFS="\t" } $4 == "N" {sub("\\.", "FAIL1_N", $7)} {print $0}' ${out_r}.vcf | awk 'BEGIN { OFS="\t" } FNR==NR{a[$1];next}  ($2 in a) {sub(/PASS/, "FAIL2_M", $7); sub("^\\.$", "FAIL2_M", $7)} {print $0}' fail_geno0.1_${CHR} - > ${out_r}.FAIL1FAIL2.vcf
awk 'BEGIN { OFS="\t" } FNR==NR{a[$1];next}  ($2 in a) {sub(/PASS/, "FAIL3_H", $7); sub("^\\.$", "FAIL3_H", $7)} {print $0}' fail_het177_${CHR} ${out_r}.FAIL1FAIL2.vcf > ${out_r}.FAIL1FAIL2FAIL3.vcf

# Add relevant information about the three filtering steps to the header and compress

##The information is saved in a text file called extra_filter
#echo "##FILTER=<ID=FAIL1_N,Description=\"Sites where there is a N in the reference genome (hg38) and previously had FILTER '.'\"> " > extra_filter
#echo "##FILTER=<ID=FAIL2_M,Description=\"Sites genotyped in less than 90% of the samples. Missingness calculated with vcftools --missing-site\"> " >> extra_filter
#echo "##FILTER=<ID=FAIL3_H,Description=\"Sites heterozygous in the 177 samples. HWE calculated with vcftools --hardy\"> " >> extra_filter

numm=$(grep -n -m1 "#CHR" ${out_r}.FAIL1FAIL2FAIL3.vcf | cut -d":" -f1)
head -$numm ${out_r}.FAIL1FAIL2FAIL3.vcf > header_${CHR}
head -18 header_${CHR} > 1header_${CHR} #keep very first lines and all lines with "FILTER" descriptions
let numms=$numm-18
tail -${numms} header_${CHR} > 2header_${CHR}
cat 1header_${CHR} extra_filter 2header_${CHR} > new_header_${CHR}
let numbb=$numm+1
tail -n +${numbb} ${out_r}.FAIL1FAIL2FAIL3.vcf > bott_${CHR}
cat new_header_${CHR} bott_${CHR} > ${out_r}.FAIL1FAIL2FAIL3.reheaded.vcf
rm header_${CHR}; rm 1header_${CHR}; rm 2header_${CHR}; rm bott_${CHR}; rm new_header_${CHR}

bgzip -f ${out_r}.FAIL1FAIL2FAIL3.reheaded.vcf
tabix -f ${out_r}.FAIL1FAIL2FAIL3.reheaded.vcf.gz

#This is template code for filtering chromosome X after SNP and indels VQSR.

#Input: output of step_X.5_indel-VQSR.sh (multi-sample, VQSRed VCF, 179 samples)
#Output: multi-sample VCF (177 samples) with additional filtering status

#Program version: GATK/3.7, tabix/0.2.6, vcftools/0.1.13
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

# Relatedness filtering 

in=ALLDATA_X_JG.179ind.recalSNP99.9.recalINDEL99.0.vcf
out_r=ALLDATA_X_JG.177ind.recalSNP99.9.recalINDEL99.0

java -Xmx6g -jar $GATK_HOME/GenomeAnalysisTK.jar -T SelectVariants --variant ${in}.gz -R ${ref} -xl_sn PNP061 -xl_sn SGDP_LP6005441-DNA_B11 -L chrX --out ${out_r}.vcf.gz

# Calculate missingness (vcftools)
# Comment: I am not doing HWE filtering for the X chromosome.
vcftools --gzvcf ${out_r}.vcf.gz --missing-site --out ${out_r}.vcf.gz

# Change the FILTER status of sites with a N in the reference (to FAIL1_N) and of sites which have more than 10 % missingness (to FAIL2_M). The filters are applied sequentially and a site has a single FILTER value (so some sites with a VQSR or a LowQual filter maybe fail missingness or HWE as well, but they won't get that filter). Non-variant sites can also get a FILTER value (instead of a .).
awk '$6 > 0.1 {print $2}' ${out_r}.vcf.gz.lmiss > fail_geno0.1_X
gunzip ${out_r}.vcf.gz
awk 'BEGIN { OFS="\t" } $4 == "N" {sub("\\.", "FAIL1_N", $7)} {print $0}' ${out_r}.vcf | awk 'BEGIN { OFS="\t" } FNR==NR{a[$1];next}  ($2 in a) {sub(/PASS/, "FAIL2_M", $7); sub("^\\.$", "FAIL2_M", $7)} {print $0}' fail_geno0.1_X - > ${out_r}.FAIL1FAIL2.vcf

# Add relevant information about the two filtering steps to the header and compress

##The information is saved in a text file called extra_filter_X
#echo "##FILTER=<ID=FAIL1_N,Description=\"Sites where there is a N in the reference genome (hg38) and previously had FILTER '.'\"> " > extra_filter
#echo "##FILTER=<ID=FAIL2_M,Description=\"Sites genotyped in less than 90% of the samples. Missingness calculated with vcftools --missing-site\"> " >> extra_filter

CHROM=X
numm=$(grep -n -m1 "#CHROM" ${out_r}.FAIL1FAIL2.vcf | cut -d":" -f1)
head -$numm ${out_r}.FAIL1FAIL2.vcf > header_${CHROM}
head -18 header_${CHROM} > 1header_${CHROM} #keep very first lines and all lines with "FILTER" descriptions
let numms=$numm-18
tail -${numms} header_${CHROM} > 2header_${CHROM}
cat 1header_${CHROM} extra_filter_X 2header_${CHROM} > new_header_${CHROM}
let numbb=$numm+1
tail -n +${numbb} ${out_r}.FAIL1FAIL2.vcf > bott_${CHROM}
cat new_header_${CHROM} bott_${CHROM} > ${out_r}.FAIL1FAIL2.H.vcf
rm header_${CHROM}; rm 1header_${CHROM}; rm 2header_${CHROM}; rm bott_${CHROM}; rm new_header_${CHROM}

bgzip -f ${out_r}.FAIL1FAIL2.H.vcf
tabix -f ${out_r}.FAIL1FAIL2.H.vcf.gz



# 2023-06-16
# Gwenna Breton
# Goal: count known and unreported variants in our newly generated data using an updated version of dbsnp.

###
# Preliminary step: retrieve and prepare dbsnp file
###
ssh gwennabr@rackham.uppmax.uu.se
screen -S dbsnp
cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp156
interactive -A p2018003 -p core -n 2 -t 2:00:00 -M snowy
##To list the files:
curl ftp://ftp.ncbi.nih.gov/snp/redesign/archive/b156/VCF/
##To download the files:
wget ftp://ftp.ncbi.nih.gov/snp/redesign/archive/b156/VCF/GCF_000001405.40.gz.md5 #And all the other files in the folder

#The relevant file for hg38 is GCF_000001405.40.gz. However the contigs are named like NC_000001.11 for chr1, etc. I need to change the contig names to what I have in my VCF files.
# I decided to keep only 1-22XYMT (I could skip Y and MT actually) and rename these to what I have in my files.
cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp156/modified_version
zgrep -v "##" ../VCF/GCF_000001405.40.gz | cut -f1 | sort | uniq > list_of_contigs
grep NC list_of_contigs > list_of_contigs_conversion_1-22XYMT
#Then I made a list that listed the "new" names and pasted the two lists together.

##Select 1-22XYMT and rename the contigs (trying to do all in one go)

#The following has been written to /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp156/modified_version/select_rename_dbsnp.sh
sbatch /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp156/modified_version/select_rename_dbsnp.sh

#!/bin/bash -l
 
#SBATCH -A p2018003
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 12:00:00
#SBATCH -J select_rename_dbsnp
#SBATCH -o select_rename_dbsnp.output
#SBATCH -e select_rename_dbsnp.output

module load bioinfo-tools
module load bcftools/1.17
invcf=/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp156/VCF/GCF_000001405.40.gz
outvcf=/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp156/modified_version/dbsnp156_1-22XYMT.vcf.gz
conversion=/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp156/modified_version/list_of_contigs_conversion_1-22XYMT # "old_name new_name\n" pairs separated by whitespaces, each on a separate line
bcftools view -Ou -r NC_000001.11,NC_000002.12,NC_000003.12,NC_000004.12,NC_000005.10,NC_000006.12,NC_000007.14,NC_000008.11,NC_000009.12,NC_000010.11,NC_000011.10,NC_000012.12,NC_000013.11,NC_000014.9,NC_000015.10,NC_000016.10,NC_000017.11,NC_000018.10,NC_000019.10,NC_000020.11,NC_000021.9,NC_000022.11,NC_000023.11,NC_000024.10,NC_012920.1 $invcf | bcftools annotate -Oz -o $outvcf --rename-chrs $conversion -

###
# Count variants in the VCF files after VQSR, relatedness, HWE and geno0.1 filtering: run Picard's CollectVariantCallingMetrics
###
#This is based on code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/sequence_processing/scripts/mapping_and_GATK_final_scripts/HC_BPresolution/initial_analyses.sh
cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/bash_outputs/2023
#chrom=22 #Test run with chr22
for chrom in {1..21}; do
(echo '#!/bin/bash -l'
echo "
module load bioinfo-tools picard/2.10.3
prefix=25KS.48RHG.104comp.HCBP.${chrom}.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded
folder=/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/
cd \$SNIC_TMP
cp \${folder}\${prefix}.vcf.gz .
cp \${folder}\${prefix}.vcf.gz.tbi .
cp /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp156/modified_version/dbsnp156_1-22XYMT.vcf.gz .
java -Xmx6g -jar \$PICARD_HOME/picard.jar CollectVariantCallingMetrics \
INPUT=\${prefix}.vcf.gz \
OUTPUT=\${prefix}.dbsnp156 \
DBSNP=dbsnp156_1-22XYMT.vcf.gz
cp \${prefix}.dbsnp156* \${folder}
exit 0") | sbatch -p core -n 1 -t 36:0:0 -A p2018003  -J filtered_${chrom}_CVCM -o filtered_${chrom}_CVCM_dbsnp156.output -e filtered_${chrom}_CVCM_dbsnp156.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL -M snowy
done
#To see stats for snowy: jobinfo -u gwennabr -M snowy

###
# Using the outputs of Picard's CollectVariantCallingMetrics, get metrics of interest (e.g. sum across 1-22, averages by populations etc)
###
#This is based on code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/sequence_processing/scripts/mapping_and_GATK_final_scripts/HC_BPresolution/countvariants/collect_metrics.sh
# This should be run on rackham, as an interactive job.

### Summary metrics

cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering
cp /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Project_4/Processing_pipeline_comparison/get_summary.sh tmp

########################
# Content of /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Project_4/Processing_pipeline_comparison/get_summary.sh
########################
file=FILE
head -8 ${file}| tail -1 > counts
TOTALSNP=$(cut -f1 counts)
NUM_IN_DB_SNP=$(cut -f2 counts)
FILTEREDSNP=$(cut -f4 counts)
DBSNPTITV=$(cut -f6 counts)
NOVELTITV=$(cut -f7 counts)
TOTALINDEL=$(cut -f8 counts)
NUM_IN_DB_SNP_INDELS=$(cut -f12 counts)
TOTALMULTIALLELICSNPS=$(cut -f15 counts)
TOTALCOMPLEXINDELS=$(cut -f17 counts)
SNPREFERENCEBIAS=$(cut -f19 counts)
NUMSINGLETONS=$(cut -f20 counts)
echo ${file} ${TOTALSNP} ${NUM_IN_DB_SNP} ${TOTALMULTIALLELICSNPS} ${TOTALINDEL} ${NUM_IN_DB_SNP_INDELS} ${TOTALCOMPLEXINDELS} ${DBSNPTITV} ${NOVELTITV} ${SNPREFERENCEBIAS} ${NUMSINGLETONS} ${FILTEREDSNP} >> OUT
rm counts
########################

sed "s/OUT/25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_summary_metrics/g" < tmp > get_summary_1-22.dbsnp156.sh; rm tmp
echo "FILE TOTALSNP NUM_IN_DB_SNP TOTALMULTIALLELICSNPS TOTALINDEL NUM_IN_DB_SNP_INDELS TOTALCOMPLEXINDELS DBSNPTITV NOVELTITV SNPREFERENCEBIAS NUMSINGLETONS FILTEREDSNP" > 25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_summary_metrics
for chr in {1..22}; do
sed "s/FILE/25KS.48RHG.104comp.HCBP.${chr}.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.variant_calling_summary_metrics/g" < get_summary_1-22.dbsnp156.sh > get_summary_${chr}.sh
bash get_summary_${chr}.sh
rm get_summary_${chr}.sh
done

#Get sum/mean/weighted mean depending on metrics with R
R
data <- read.table(file="25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_summary_metrics",header=TRUE)
header=c("TOTALSNP","NUM_IN_DB_SNP","TOTALMULTIALLELICSNPS","TOTALINDEL","NUM_IN_DB_SNP_INDELS","TOTALCOMPLEXINDELS","NUMSINGLETONS","FILTEREDSNP","PCT_DB_SNP_SNP","PCT_DB_SNP_INDEL","DBSNPTITV","NOVELTITV","SNPREFERENCEBIAS")
write.table(file="25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_summary_metrics.AVG",x=t(c(sum(data$TOTALSNP),sum(data$NUM_IN_DB_SNP),sum(data$TOTALMULTIALLELICSNPS),sum(data$TOTALINDEL),sum(data$NUM_IN_DB_SNP_INDELS),sum(data$TOTALCOMPLEXINDELS),sum(data$NUMSINGLETONS),sum(data$FILTEREDSNP),sum(data$NUM_IN_DB_SNP)/sum(data$TOTALSNP),sum(data$NUM_IN_DB_SNP_INDELS)/sum(data$TOTALINDEL),sum(data$DBSNPTITV*(data$NUM_IN_DB_SNP/sum(data$NUM_IN_DB_SNP))),sum(data$NOVELTITV*((data$TOTALSNP-data$NUM_IN_DB_SNP)/sum(data$TOTALSNP-data$NUM_IN_DB_SNP))),sum(data$SNPREFERENCEBIAS*(data$TOTALSNP/sum(data$TOTALSNP))))),col.names=header,row.names=FALSE)
q()
n

### Detailed metrics

cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering
cp /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Project_4/Processing_pipeline_comparison/get_summary_detail.sh get_summary_detail.sh

########################
# Content of /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Project_4/Processing_pipeline_comparison/get_summary_detail.sh
########################
file=FILE
ind=INDIV
grep ${ind} ${file} > counts
TOTALSNP=$(cut -f6 counts)
NUM_IN_DB_SNP=$(cut -f7 counts)
FILTEREDSNP=$(cut -f9 counts)
DBSNPTITV=$(cut -f11 counts)
NOVELTITV=$(cut -f12 counts)
TOTALINDEL=$(cut -f13 counts)
NUM_IN_DB_SNP_INDELS=$(cut -f17 counts)
TOTALMULTIALLELICSNPS=$(cut -f20 counts)
TOTALCOMPLEXINDELS=$(cut -f22 counts)
SNPREFERENCEBIAS=$(cut -f24 counts)
NUMSINGLETONS=$(cut -f25 counts)
TOTAL_GQ0_VARIANTS=$(cut -f4 counts)
TOTAL_HET_DEPTH=$(cut -f5 counts)
echo ${file} ${ind} ${TOTALSNP} ${NUM_IN_DB_SNP} ${TOTALMULTIALLELICSNPS} ${TOTALINDEL} ${NUM_IN_DB_SNP_INDELS} ${TOTALCOMPLEXINDELS} ${DBSNPTITV} ${NOVELTITV} ${SNPREFERENCEBIAS} ${NUMSINGLETONS} ${FILTEREDSNP} ${TOTAL_GQ0_VARIANTS} ${TOTAL_HET_DEPTH} >> OUT
rm counts
########################

#Step 1: make one file per chr with metrics of interest for each chromosome
for IND in HGDP_HGDP00998 SGDP_EGAR00001482721_LP6005519-DNA_A12 SAHGP_EGAZ00001314208_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_F02_Assembly_LP6005857-DNA_F02.bam SGDP_LP6005441-DNA_E07 SGDP_LP6005441-DNA_A08 PNP012 SAHGP_EGAZ00001314207_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_E02_Assembly_LP6005857-DNA_E02 PNP011 SAHGP_EGAZ00001314200_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_F01_Assembly_LP6005857-DNA_F01 PNP010 SGDP_LP6005441-DNA_A05 PNP005 PNP004 SGDP_LP6005443-DNA_G07 PNP003 SGDP_LP6005443-DNA_G08 PNP002 SGDP_LP6005441-DNA_A11 KSP152 KSP150 PNP006 HGDP_HGDP01284 KSP154 SGDP_LP6005442-DNA_D09 KSP155 SGDP_LP6005443-DNA_G02 SGDP_LP6005443-DNA_C08 PNP081 PNP080 SGDP_LP6005677-DNA_D03 PNP084 PNP083 PNP082 HGDP_DNK02 PNP001 PNP000 SGDP_LP6005442-DNA_E11 SGDP_LP6005619-DNA_B01 SAHGP_EGAZ00001314209_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_G02_Assembly_LP6005857-DNA_G02 KSP140 SGDP_LP6005592-DNA_C05 SAHGP_EGAZ00001314216_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_F03_Assembly_LP6005857-DNA_F03 KSP146 SGDP_LP6005592-DNA_C03 SAHGP_EGAZ00001314213_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_C03_Assembly_LP6005857-DNA_C03 PNP070 SGDP_LP6005441-DNA_F07 PNP074 PNP073 PNP072 SGDP_LP6005441-DNA_B08 PNP071 SGDP_LP6005441-DNA_F01 SGDP_LP6005441-DNA_B05 SAHGP_EGAZ00001314196_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_B01_Assembly_LP6005857-DNA_B01 SGDP_LP6005443-DNA_D08 SAHGP_EGAZ00001314214_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_D03_Assembly_LP6005857-DNA_D03 SGDP_LP6005443-DNA_H08 SGDP_LP6005441-DNA_B10 SAHGP_EGAZ00001314195_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_A01_Assembly_LP6005857-DNA_A01 SAHGP_EGAZ00001314202_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_H01_Assembly_LP6005857-DNA_H01 SAHGP_EGAZ00001314215_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_E03_Assembly_LP6005857-DNA_E03 NA12892 HGDP_HGDP00927 NA12891 SGDP_LP6005677-DNA_G01 PNP063 PNP062 PNP060 HGDP_HGDP00521 PNP066 PNP065 PNP064 SGDP_LP6005442-DNA_H11 SGDP_LP6005442-DNA_H10 SGDP_LP6005441-DNA_B02 HG02568 SGDP_EGAR00001482718_LP6005677-DNA_D04 SGDP_LP6005619-DNA_C01 SGDP_SS6004468 SGDP_SS6004467 Rasmussen_KAR4 SAHGP_EGAZ00001314210_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_H02_Assembly_LP6005857-DNA_H02 NA19017 SGDP_LP6005441-DNA_G08 SGDP_LP6005441-DNA_G06 PNP052 PNP051 PNP050 SGDP_LP6005441-DNA_G02 SGDP_EGAR00001482728_LP6005519-DNA_A09 SAHGP_EGAZ00001314217_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_G03_Assembly_LP6005857-DNA_G03 SAHGP_EGAZ00001314199_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_E01_Assembly_LP6005857-DNA_E01 PNP054 SGDP_LP6005442-DNA_B10 PNP053 SGDP_SS6004476 SGDP_LP6005442-DNA_F09 SGDP_SS6004475 SGDP_LP6005443-DNA_E02 KSP111 SGDP_SS6004473 KSP116 SGDP_SS6004471 SGDP_SS6004470 SGDP_LP6005443-DNA_E06 SGDP_SS6004480 KSP228 SGDP_LP6005443-DNA_A01 PNP041 PNP040 SGDP_LP6005442-DNA_B02 PNP044 HGDP_HGDP00542 PNP043 PNP042 SAHGP_EGAZ00001314197_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_C01_Assembly_LP6005857-DNA_C01 SGDP_LP6005442-DNA_G11 SGDP_LP6005442-DNA_G10 KSP065 SAHGP_EGAZ00001314206_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_D02_Assembly_LP6005857-DNA_D02 KSP062 KSP063 SAHGP_EGAZ00001314201_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_G01_Assembly_LP6005857-DNA_G01 KSP069 SAHGP_EGAZ00001314203_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_A02_Assembly_LP6005857-DNA_A02 KSP067 KSP105 KSP106 KSP224 KSP103 KSP225 HGDP_HGDP01307 SGDP_LP6005441-DNA_H08 SGDP_EGAR00001482719_LP6005677-DNA_C04 SGDP_LP6005441-DNA_H06 SGDP_LP6005442-DNA_A10 PNP030 SGDP_LP6005441-DNA_H02 SAHGP_EGAZ00001314204_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_B02_Assembly_LP6005857-DNA_B02 PNP034 SGDP_LP6005441-DNA_D04 PNP033 PNP032 HGDP_HGDP01029 PNP031 HGDP_HGDP00456 SGDP_LP6005443-DNA_F06 SGDP_EGAR00001482720_LP6005519-DNA_B12 PNP024 KSP092 SAHGP_EGAZ00001314212_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_B03_Assembly_LP6005857-DNA_B03 KSP096 KSP134 SGDP_LP6005443-DNA_F02 KSP139 SGDP_LP6005443-DNA_B08 SGDP_LP6005443-DNA_B09 KSP137 HG00759 SAHGP_EGAZ00001314205_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_C02_Assembly_LP6005857-DNA_C02 SAHGP_EGAZ00001314211_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_A03_Assembly_LP6005857-DNA_A03 SAHGP_EGAZ00001314198_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_D01_Assembly_LP6005857-DNA_D01 SAHGP_EGAZ00001314218_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_H03_Assembly_LP6005857-DNA_H03 SGDP_LP6005443-DNA_B01 PNP023 SGDP_LP6005442-DNA_A02 PNP022 PNP021 HG03052 PNP020 SGDP_LP6005442-DNA_F11 PNP014 PNP013 SGDP_LP6005592-DNA_D03 KSP124 HG02922; do
sed "s/OUT/25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_detail_metrics.${IND}/g" < get_summary_detail.sh | sed "s/INDIV/${IND}/g" > get_summary_detail${IND}.sh
echo "FILE INDIVIDUAL TOTALSNP NUM_IN_DB_SNP TOTALMULTIALLELICSNPS TOTALINDEL NUM_IN_DB_SNP_INDELS TOTALCOMPLEXINDELS DBSNPTITV NOVELTITV SNPREFERENCEBIAS NUMSINGLETONS FILTEREDSNP TOTAL_GQ0_VARIANTS TOTAL_HET_DEPTH" > 25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_detail_metrics.${IND}
for chr in {1..22}; do
sed "s/FILE/25KS.48RHG.104comp.HCBP.${chr}.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.variant_calling_detail_metrics/g" get_summary_detail${IND}.sh > get_summary_detail${IND}_${chr}.sh
bash get_summary_detail${IND}_${chr}.sh
rm get_summary_detail${IND}_${chr}.sh
done
rm get_summary_detail${IND}.sh
done

#Step 2: make a file for all individuals with one line per individual for 1-22 metrics (sum, avg, etc depending on case) and then four lines across the callset: colMeans, StDev, min, max.
# Based on code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/sequence_processing/scripts/mapping_and_GATK_final_scripts/HC_BPresolution/countvariants/VCF5_details.R

header=c("TOTALSNP","NUM_IN_DB_SNP","TOTALMULTIALLELICSNPS","TOTALINDEL","NUM_IN_DB_SNP_INDELS","TOTALCOMPLEXINDELS","NUMSINGLETONS",
         "FILTEREDSNP","PCT_DB_SNP_SNP","PCT_DB_SNP_INDEL","DBSNPTITV","NOVELTITV","SNPREFERENCEBIAS","TOTAL_GQ0_VARIANTS","TOTAL_HET_DEPTH")
INDIV <- c("HGDP_HGDP00998","SGDP_EGAR00001482721_LP6005519-DNA_A12","SAHGP_EGAZ00001314208_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_F02_Assembly_LP6005857-DNA_F02.bam","SGDP_LP6005441-DNA_E07","SGDP_LP6005441-DNA_A08","PNP012","SAHGP_EGAZ00001314207_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_E02_Assembly_LP6005857-DNA_E02","PNP011","SAHGP_EGAZ00001314200_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_F01_Assembly_LP6005857-DNA_F01","PNP010","SGDP_LP6005441-DNA_A05","PNP005","PNP004","SGDP_LP6005443-DNA_G07","PNP003","SGDP_LP6005443-DNA_G08","PNP002","SGDP_LP6005441-DNA_A11","KSP152","KSP150","PNP006","HGDP_HGDP01284","KSP154","SGDP_LP6005442-DNA_D09","KSP155","SGDP_LP6005443-DNA_G02","SGDP_LP6005443-DNA_C08","PNP081","PNP080","SGDP_LP6005677-DNA_D03","PNP084","PNP083","PNP082","HGDP_DNK02","PNP001","PNP000","SGDP_LP6005442-DNA_E11","SGDP_LP6005619-DNA_B01","SAHGP_EGAZ00001314209_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_G02_Assembly_LP6005857-DNA_G02","KSP140","SGDP_LP6005592-DNA_C05","SAHGP_EGAZ00001314216_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_F03_Assembly_LP6005857-DNA_F03","KSP146","SGDP_LP6005592-DNA_C03","SAHGP_EGAZ00001314213_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_C03_Assembly_LP6005857-DNA_C03","PNP070","SGDP_LP6005441-DNA_F07","PNP074","PNP073","PNP072","SGDP_LP6005441-DNA_B08","PNP071","SGDP_LP6005441-DNA_F01","SGDP_LP6005441-DNA_B05","SAHGP_EGAZ00001314196_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_B01_Assembly_LP6005857-DNA_B01","SGDP_LP6005443-DNA_D08","SAHGP_EGAZ00001314214_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_D03_Assembly_LP6005857-DNA_D03","SGDP_LP6005443-DNA_H08","SGDP_LP6005441-DNA_B10","SAHGP_EGAZ00001314195_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_A01_Assembly_LP6005857-DNA_A01","SAHGP_EGAZ00001314202_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_H01_Assembly_LP6005857-DNA_H01","SAHGP_EGAZ00001314215_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_E03_Assembly_LP6005857-DNA_E03","NA12892","HGDP_HGDP00927","NA12891","SGDP_LP6005677-DNA_G01","PNP063","PNP062","PNP060","HGDP_HGDP00521","PNP066","PNP065","PNP064","SGDP_LP6005442-DNA_H11","SGDP_LP6005442-DNA_H10","SGDP_LP6005441-DNA_B02","HG02568","SGDP_EGAR00001482718_LP6005677-DNA_D04","SGDP_LP6005619-DNA_C01","SGDP_SS6004468","SGDP_SS6004467","Rasmussen_KAR4","SAHGP_EGAZ00001314210_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_H02_Assembly_LP6005857-DNA_H02","NA19017","SGDP_LP6005441-DNA_G08","SGDP_LP6005441-DNA_G06","PNP052","PNP051","PNP050","SGDP_LP6005441-DNA_G02","SGDP_EGAR00001482728_LP6005519-DNA_A09","SAHGP_EGAZ00001314217_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_G03_Assembly_LP6005857-DNA_G03","SAHGP_EGAZ00001314199_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_E01_Assembly_LP6005857-DNA_E01","PNP054","SGDP_LP6005442-DNA_B10","PNP053","SGDP_SS6004476","SGDP_LP6005442-DNA_F09","SGDP_SS6004475","SGDP_LP6005443-DNA_E02","KSP111","SGDP_SS6004473","KSP116","SGDP_SS6004471","SGDP_SS6004470","SGDP_LP6005443-DNA_E06","SGDP_SS6004480","KSP228","SGDP_LP6005443-DNA_A01","PNP041","PNP040","SGDP_LP6005442-DNA_B02","PNP044","HGDP_HGDP00542","PNP043","PNP042","SAHGP_EGAZ00001314197_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_C01_Assembly_LP6005857-DNA_C01","SGDP_LP6005442-DNA_G11","SGDP_LP6005442-DNA_G10","KSP065","SAHGP_EGAZ00001314206_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_D02_Assembly_LP6005857-DNA_D02","KSP062","KSP063","SAHGP_EGAZ00001314201_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_G01_Assembly_LP6005857-DNA_G01","KSP069","SAHGP_EGAZ00001314203_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_A02_Assembly_LP6005857-DNA_A02","KSP067","KSP105","KSP106","KSP224","KSP103","KSP225","HGDP_HGDP01307","SGDP_LP6005441-DNA_H08","SGDP_EGAR00001482719_LP6005677-DNA_C04","SGDP_LP6005441-DNA_H06","SGDP_LP6005442-DNA_A10","PNP030","SGDP_LP6005441-DNA_H02")
INDIV2 <- c("SAHGP_EGAZ00001314204_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_B02_Assembly_LP6005857-DNA_B02","PNP034","SGDP_LP6005441-DNA_D04","PNP033","PNP032","HGDP_HGDP01029","PNP031","HGDP_HGDP00456","SGDP_LP6005443-DNA_F06","SGDP_EGAR00001482720_LP6005519-DNA_B12","PNP024","KSP092","SAHGP_EGAZ00001314212_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_B03_Assembly_LP6005857-DNA_B03","KSP096","KSP134","SGDP_LP6005443-DNA_F02","KSP139","SGDP_LP6005443-DNA_B08","SGDP_LP6005443-DNA_B09","KSP137","HG00759","SAHGP_EGAZ00001314205_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_C02_Assembly_LP6005857-DNA_C02","SAHGP_EGAZ00001314211_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_A03_Assembly_LP6005857-DNA_A03","SAHGP_EGAZ00001314198_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_D01_Assembly_LP6005857-DNA_D01","SAHGP_EGAZ00001314218_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_H03_Assembly_LP6005857-DNA_H03","SGDP_LP6005443-DNA_B01","PNP023","SGDP_LP6005442-DNA_A02","PNP022","PNP021","HG03052","PNP020","SGDP_LP6005442-DNA_F11","PNP014","PNP013","SGDP_LP6005592-DNA_D03","KSP124","HG02922")
INDIVALL <- c(INDIV,INDIV2)
Mat <- matrix(0,nrow=(length(INDIVALL)+4),ncol=15)
for (i in 1:length(INDIVALL)) {
  IND <- INDIVALL[i]
  data <- read.table(file=paste("25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_detail_metrics.",IND,sep=""),header=TRUE)
  Mat[i,] <- c(sum(data$TOTALSNP),sum(data$NUM_IN_DB_SNP),sum(data$TOTALMULTIALLELICSNPS),
               sum(data$TOTALINDEL),sum(data$NUM_IN_DB_SNP_INDELS),sum(data$TOTALCOMPLEXINDELS),sum(data$NUMSINGLETONS),sum(data$FILTEREDSNP),sum(data$NUM_IN_DB_SNP)/sum(data$TOTALSNP),sum(data$NUM_IN_DB_SNP_INDELS)/sum(data$TOTALINDEL),sum(data$DBSNPTITV*(data$NUM_IN_DB_SNP/sum(data$NUM_IN_DB_SNP))),sum(data$NOVELTITV*((data$TOTALSNP-data$NUM_IN_DB_SNP)/sum(data$TOTALSNP-data$NUM_IN_DB_SNP))),sum(data$SNPREFERENCEBIAS*(data$TOTALSNP/sum(data$TOTALSNP))),sum(data$TOTAL_GQ0_VARIANTS),sum(data$TOTAL_HET_DEPTH))
}
#Take average across individuals
Mat[178,] <- c(colMeans(Mat[1:length(INDIVALL),]))
Mat[179,] <- apply(Mat[1:length(INDIVALL),],2,sd)
Mat[180,] <- apply(Mat[1:length(INDIVALL),],2,min)
Mat[181,] <- apply(Mat[1:length(INDIVALL),],2,max)
#Write out
write.table(file="25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_detail_metrics.AVG",x=Mat,col.names=header,row.names=c(INDIVALL,"COL_MEANS","StDev","MIN","MAX"),append=FALSE)

###
# Count variants in our dataset only (KS and central Africa)
###
#I decided to not copy back the subsetted VCF from scratch. If I need it for something else, I can run the job again.
#I kept it for chromosome 22 in case I want to try stuff.
cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/bash_outputs/2023
for chrom in {1..21}; do
#chrom=22
(echo '#!/bin/bash -l'
echo "
folder=/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/
prefix=25KS.48RHG.104comp.HCBP.${chrom}.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded
newprefix=25KS.48RHG.HCBP.${chrom}.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded
samplelist=25KS.48RHG_list #list of samples, one sample per row
cd \$SNIC_TMP
cp \${folder}\${prefix}.vcf.gz .
cp \${folder}25KS.48RHG_list .
cp /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp156/modified_version/dbsnp156_1-22XYMT.vcf.gz .

#Step1: select the individuals
module load bioinfo-tools bcftools/1.17
bcftools view -S \$samplelist -o \$newprefix.vcf.gz -Oz \$prefix.vcf.gz
bcftools index --tbi \$newprefix.vcf.gz

#Step2: calculate the sumstats
module load bioinfo-tools picard/2.10.3
java -Xmx6g -jar \$PICARD_HOME/picard.jar CollectVariantCallingMetrics \
INPUT=\${newprefix}.vcf.gz \
OUTPUT=\${newprefix}.dbsnp156 \
DBSNP=dbsnp156_1-22XYMT.vcf.gz

#Step3: copy everything back
cp \${newprefix}.dbsnp156* \${folder}
#cp \${newprefix}.vcf.gz* \${folder}
exit 0") | sbatch -p core -n 1 -t 36:0:0 -A p2018003  -J select_and_CVCM_${chrom} -o select_and_CVCM_${chrom}_dbsnp156.output -e  select_and_CVCM_${chrom}_dbsnp156.output --mail-user gwenna.breton@ebc.uu.se --mail-type=END,FAIL -M snowy
done

###
# Using the outputs of Picard's CollectVariantCallingMetrics, get metrics of interest (e.g. sum across 1-22)
###
#This is based on code in /Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/sequence_processing/scripts/mapping_and_GATK_final_scripts/HC_BPresolution/countvariants/collect_metrics.sh
# This should be run on rackham, as an interactive job.

### Summary metrics

cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering
cp /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Project_4/Processing_pipeline_comparison/get_summary.sh tmp

########################
# Content of /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Project_4/Processing_pipeline_comparison/get_summary.sh
########################
file=FILE
head -8 ${file}| tail -1 > counts
TOTALSNP=$(cut -f1 counts)
NUM_IN_DB_SNP=$(cut -f2 counts)
FILTEREDSNP=$(cut -f4 counts)
DBSNPTITV=$(cut -f6 counts)
NOVELTITV=$(cut -f7 counts)
TOTALINDEL=$(cut -f8 counts)
NUM_IN_DB_SNP_INDELS=$(cut -f12 counts)
TOTALMULTIALLELICSNPS=$(cut -f15 counts)
TOTALCOMPLEXINDELS=$(cut -f17 counts)
SNPREFERENCEBIAS=$(cut -f19 counts)
NUMSINGLETONS=$(cut -f20 counts)
echo ${file} ${TOTALSNP} ${NUM_IN_DB_SNP} ${TOTALMULTIALLELICSNPS} ${TOTALINDEL} ${NUM_IN_DB_SNP_INDELS} ${TOTALCOMPLEXINDELS} ${DBSNPTITV} ${NOVELTITV} ${SNPREFERENCEBIAS} ${NUMSINGLETONS} ${FILTEREDSNP} >> OUT
rm counts
########################

sed "s/OUT/25KS.48RHG.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_summary_metrics/g" < tmp > get_summary_25KS.48RHG.1-22.dbsnp156.sh; rm tmp
echo "FILE TOTALSNP NUM_IN_DB_SNP TOTALMULTIALLELICSNPS TOTALINDEL NUM_IN_DB_SNP_INDELS TOTALCOMPLEXINDELS DBSNPTITV NOVELTITV SNPREFERENCEBIAS NUMSINGLETONS FILTEREDSNP" > 25KS.48RHG.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_summary_metrics
for chr in {1..22}; do
sed "s/FILE/25KS.48RHG.HCBP.${chr}.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.variant_calling_summary_metrics/g" < get_summary_25KS.48RHG.1-22.dbsnp156.sh > get_summary_${chr}.sh
bash get_summary_${chr}.sh
rm get_summary_${chr}.sh
done

#Get sum/mean/weighted mean depending on metrics with R
R
data <- read.table(file="25KS.48RHG.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_summary_metrics",header=TRUE)
header=c("TOTALSNP","NUM_IN_DB_SNP","TOTALMULTIALLELICSNPS","TOTALINDEL","NUM_IN_DB_SNP_INDELS","TOTALCOMPLEXINDELS","NUMSINGLETONS","FILTEREDSNP","PCT_DB_SNP_SNP","PCT_DB_SNP_INDEL","DBSNPTITV","NOVELTITV","SNPREFERENCEBIAS")
write.table(file="25KS.48RHG.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_summary_metrics.AVG",x=t(c(sum(data$TOTALSNP),sum(data$NUM_IN_DB_SNP),sum(data$TOTALMULTIALLELICSNPS),sum(data$TOTALINDEL),sum(data$NUM_IN_DB_SNP_INDELS),sum(data$TOTALCOMPLEXINDELS),sum(data$NUMSINGLETONS),sum(data$FILTEREDSNP),sum(data$NUM_IN_DB_SNP)/sum(data$TOTALSNP),sum(data$NUM_IN_DB_SNP_INDELS)/sum(data$TOTALINDEL),sum(data$DBSNPTITV*(data$NUM_IN_DB_SNP/sum(data$NUM_IN_DB_SNP))),sum(data$NOVELTITV*((data$TOTALSNP-data$NUM_IN_DB_SNP)/sum(data$TOTALSNP-data$NUM_IN_DB_SNP))),sum(data$SNPREFERENCEBIAS*(data$TOTALSNP/sum(data$TOTALSNP))))),col.names=header,row.names=FALSE)
q()
n


#This is template code for calling variants on chromosome X and emitting a gVCF file with information about all variable & non variable positions.

# Input: output of step_A.9_indel-realignment.sh (recalibrated, dedup, indel realigned BAM)
# Output: gVCF

#Program version: GATK/3.7, tabix/0.2.6
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

java -Xmx30g -jar /sw/apps/bioinfo/GATK/3.7/GenomeAnalysisTK.jar -T HaplotypeCaller \
-nct 5 \
-R ${reference_hg38} \
-I sampleID_merge.3mask_recal.1-22X.dedup.realn.bam \
--genotyping_mode DISCOVERY \
-stand_call_conf 30 \
-ploidy ##1 for male samples, 2 for female samples## \
--emitRefConfidence BP_RESOLUTION \
--dbsnp /proj/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/dbsnp144/00_all_newchrnames.vcf.gz \
-L chrX \
-G Standard -G AS_Standard -G StandardHC \
-o sampleID_HC_AS_X.g.vcf

bgzip -f sampleID_HC_AS_X.g.vcf
tabix -f sampleID_HC_AS_X.g.vcf.gz

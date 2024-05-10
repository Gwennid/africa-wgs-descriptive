#This is template code for merging the lanes belonging to a sample and calling variants with HaplotypeCaller.

#Input: output of step_A.2_indel-realignment.sh
#Output: a VCF file with SNPs and indels

#Program version: samtools/1.1, picard/1.126, GATK/3.5, vcftools/0.1.13, tabix/0.2.6.
path_to_reference=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

# Step 1: merge the different lanes for each sample
ls indels_realigned_bam/realigned_perlane/sampleID_L?.dedup.realn.bam > indels_realigned_bam/realigned_perlane/bam_list_ sampleID
samtools merge indels_realigned_bam/realigned_perlane/sampleID_merge.dedup.realn.bam -b indels_realigned_bam/realigned_perlane/bam_list_ sampleID

# Step 2: sort the resulting BAM
java -Xmx14g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar SortSam \ INPUT=indels_realigned_bam/realigned_perlane/sampleID_merge.dedup.realn.bam \ OUTPUT=indels_realigned_bam/realigned_perlane/sampleID_merge.dedup.realn.sorted.bam \ SORT_ORDER=coordinate \
CREATE_INDEX=true

# Step 3: variant calling for the autosomes and X chromosome. The ploidy parameter is set to 2 for the autosomes. It is not set for the X chromosome.
## Command for the autosomes:
java -Xmx35g -jar $GATK_HOME/GenomeAnalysisTK.jar -T HaplotypeCaller \
-nct 5 \
-R path_to_reference \
-I indels_realigned_bam/realigned_perlane/sampleID_merge.dedup.realn.sorted.bam \
--genotyping_mode DISCOVERY \
-stand_emit_conf 30 \
-stand_call_conf 30 \
-ploidy 2 \
-L interval_lists/chr_random_Un_autosomes.intervals \
-o sampleID_directcall_rawcalls_1-22.vcf

## Command for chromosome X:
java -Xmx35g -jar $GATK_HOME/GenomeAnalysisTK.jar -T HaplotypeCaller \
	-nct 5 \
	-R path_to_reference \
	-I indels_realigned_bam/realigned_perlane/sampleID_merge.dedup.realn.sorted.bam \
	--genotyping_mode DISCOVERY \
	-stand_emit_conf 30 \
	-stand_call_conf 30 \
	-L chrX \
	-o sampleID_directcall_rawcalls_chrX.vcf

# Step 4: the resulting VCF are compressed with bgzip, the VCF for 1-22 and for chromosome X are concatenated and the resulting VCF is indexed.
bgzip sampleID_directcall_rawcalls_1-22.vcf
bgzip sampleID_directcall_rawcalls_chrX.vcf
vcf-concat sampleID_directcall_rawcalls_1-22.vcf.gz sampleID_directcall_rawcalls_chrX.vcf.gz | bgzip > sampleID_directcall_rawcalls_1-22X.vcf.gz
tabix sampleID_directcall_rawcalls_1-22X.vcf.gz

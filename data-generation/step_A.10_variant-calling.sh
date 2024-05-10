# This is template code for calling variants and emitting a gVCF file with information about every position in the reference genome.
# This step is run by chromosome, and only for the contigs "chr1" to "chr22" (autosomes).

# Input: output of step_A.9_indel-realignment.sh (recalibrated, dedup, indel realigned BAM)
# Output: gVCF

#Program version: GATK/3.7
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

for CHR in {1..22}; do
java -Xmx32g -jar /sw/apps/bioinfo/GATK/3.7/GenomeAnalysisTK.jar -T HaplotypeCaller \
	-nct 4 \
	-R ${reference_hg38} \
	-I sampleID_merge.3mask_recal.1-22X.dedup.realn.bam \
	--genotyping_mode DISCOVERY \
	-stand_call_conf 30 \
	-ploidy 2 \
	--emitRefConfidence BP_RESOLUTION \
	--dbsnp ${dbsnp150} \
	-L chr${CHR} \
	-G Standard -G AS_Standard -G StandardHC \
	-o sampleID_merge.3mask_recal.1-22X.dedup.realn_${CHR}.g.vcf.gz
done

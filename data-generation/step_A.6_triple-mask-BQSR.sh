#This is template code for performing "triple mask BQSR", by lane.
# Performed on the main chromsomal contigs (e.g. chr1), on the "random" contigs (e.g. chr1_KI270706v1_random) and on the contigs not attributed to a given chromosome (e.g. chrUn_KI270302v1). "alt" contigs are excluded. Y chromosome and mitochondrial contigs are excluded.

#Input:  output of step_A.2_indel-realignment.sh (BAM), outputs of step_A.3_variant-calling.sh and step_A.5_variant-calling.sh (VCFs)
#Output: recalibrated BAM

#Program version: GATK/3.5.0
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

# Step A.6.1: recalibration table
java -Xmx42g -jar $GATK_HOME/GenomeAnalysisTK.jar -T BaseRecalibrator \
-nct 5 \
-R ${reference_hg38} \
-I ${output.realigned}.bam \
-L ${interval} \
-knownSites ${dbsnp144} \
-knownSites sampleID_directcall_rawcalls_1-22X.vcf.gz \
-knownSites sampleID_callafterBQSRdb_rawcalls_1-22X.vcf.gz \
-o ${output.realigned.3maskbqsred}.table

# Step A.6.2: apply the recalibration table
java -Xmx42g -jar $GATK_HOME/GenomeAnalysisTK.jar -T PrintReads \
-nct 5 \
-R ${reference_hg38} \
-I ${output.realigned}.bam \
-L ${interval} \
-BQSR ${output.realigned.3maskbqsred}.table \
-o ${output.realigned.3maskbqsred}.bam \
--disable_indel_quals

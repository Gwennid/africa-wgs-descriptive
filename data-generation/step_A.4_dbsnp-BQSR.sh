#This is template code for performing Base Quality Score Recalibration (BQSR) step with recommended reference dataset, by lane.
#The interval list contains the autosomes, chromosome X, and corresponding "unknown" and "random" contigs.

#Input: output of step_A.2_indel-realignment.sh
#Output: recalibrated BAM

#Program version: GATK/3.5.0
reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

# Step A.4.1: recalibration table
java -Xmx28g -jar $GATK_HOME/GenomeAnalysisTK.jar -T BaseRecalibrator \
	-R ${reference_hg38} \
	-I ${input}.bam \
	-knownSites ${dbsnp144}.vcf.gz \
	-o ${output.bqsred}.table \
	-L ${interval} \
	-nct 4

# Step A.4.2: apply the recalibration
java -Xmx28g -jar $GATK_HOME/GenomeAnalysisTK.jar -T PrintReads \
	-R ${reference_hg38} \
	-I ${input}.bam \
	-BQSR ${output.bqsred}.table \
	-o ${output.bqsred}.bam \
	-L ${interval} \
	-nct 4 \
	--disable_indel_quals

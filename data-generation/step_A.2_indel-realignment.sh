#This is template code for indel realignment.
#This is applied to the output of step_A.1_mark-duplicates.sh, "sampleID_Llane.dedup.bam"

# Performed on the main chromsomal contigs (e.g. chr1), on the "random" contigs (e.g. chr1_KI270706v1_random) and on the contigs not attributed to a given chromosome (e.g. chrUn_KI270302v1). "alt" contigs are excluded.
#Program version: GATK/3.5.0

reference_hg38=/path/to/ref/GRCh38_full_analysis_set_plus_decoy_hla.fa.alt

# Identify regions that need to be realigned
java -Xmx7g -jar $GATK_HOME/GenomeAnalysisTK.jar -T RealignerTargetCreator \
	-R ${reference_hg38} \
	-I ${input}.bam \
	-o ${input}_realignment_targets.list \
	-L ${interval}

# Realign
java -Xmx7g -jar $GATK_HOME/GenomeAnalysisTK.jar -T IndelRealigner \
	-R ${reference_hg38} \
	-I ${input}.bam \
	-targetIntervals ${input}_realignment_targets.list \
	-o ${output.realigned}.bam \
	-L ${interval}

#This is template code for creating a BAM file with mapped reads and a BAM file with unmapped reads.
#This is applied to the output of step_0.1.[a,b,c]_mapping.sh

#Program version: samtools/1.1, picard/1.126

samtools view -b -f 4 input_sorted.bam > output_sorted_unmapped.bam
java -Xmx7g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar BuildBamIndex INPUT=output_sorted_unmapped.bam
samtools view -b -F 4 input_sorted.bam > output_sorted_mapped.bam
java -Xmx7g -jar /pica/sw/apps/bioinfo/picard/1.126/milou/picard.jar BuildBamIndex INPUT=output_sorted_mapped.bam

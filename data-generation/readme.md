This folder contains information regarding how the data was generated.

The numbers refer to the processing flowchart.

- [ ] Insert the (updated) flowchart
- [ ] Add information about the QC
- [ ] Add processing chromosome X
- [ ] What about chromosome Y and mitochondria? Skip for now? In that case, remove from flowchart?

# Mapping

## Step0.1

We mapped reads to GRCh38 using bwakit/0.7.12 `bwa-mem` with the alt-aware procedure. The resulting BAM file was sorted and indexed. The mapping was done by lane for the data generated in this study, and by what we assumed to be lanes for the comparative dataset. The code changes depending on the input:

- FASTQ: data generated in this study, SGDP (except "SGDP letter") and KGP: [step0.1.a_mapping.sh](step0.1.a_mapping.sh)
- mapped BAM: SGDP letter (IGB1, IGB2, KON2, LEM1, LEM2), HGDP, SAHGP: [step0.1.b_mapping.sh](step0.1.b_mapping.sh)
- mapped BAM from which reads of interest need to be extracted: Schlebusch et al. 2020 (the same 25 Khoe-San individuals as included in this study):  [step0.1.c_mapping.sh](step0.1.c_mapping.sh)

## Step0.2

In order to reduce the size of the BAM files we split the indexed BAM bwa into one BAM containing mapped reads and one containing unmapped reads (with samtools/1.1). Only the files with mapped reads were processed further. This is done in: [step_0.2_split-mapped-unmapped.sh](step_0.2_split-mapped-unmapped.sh)

# Processing autosomes and chromosome X

Steps A1 to A9 are common to the autosomes and the chromosome X. From step A10, the autosomes (chromosomes 1 to 22) are extracted. See separate steps for chromosome X.

We adapted the “GATK Best Practices” (McKenna et al. 2010)⁠ for the processing of the autosomes and of the X chromosome to retain as much diversity as possible ([processing pipeline](link to the processing pipeline), Breton et al. 2021, Schlebusch et al. 2020). We used GATK/3.5 for most steps. In particular our pipeline includes the step “realignment around indels” as recommended prior to release of GATK/3.6. We used GATK/3.7 from the final HaplotypeCaller command and downstream, due to an issue with the MQ (mapping quality) estimates with older versions. [processing pipeline](link to the processing pipeline) specifies at which level – lane, sample, batch or all samples – each step was performed. Only the final steps (joint genotyping and refinement of the callset) are performed on all samples together, making it easy to add new samples as more data is generated.

## Processing by lane: steps A1 and A2

We marked duplicate reads with picard/1.126: [step_A.1_mark-duplicates.sh](step_A.1_mark-duplicates.sh)

We realigned around indels with GATK/3.5.0: [step_A.2_indel-realignment.sh](step_A.2_indel-realignment.sh)

For realignment, the interval list file contains the 22 autosomes as well as chromosomes X, Y and the mitochondria. Moreover it contains contigs of the type “chr1_KI270706v1_random”, that are known to belong to a specific chromosome but for which the exact order or orientation is unknown, and contigs of the type “chrUn_KI270302v1” that cannot be confidently located on a specific chromosome. It does not contain the alt contigs.

## Triple mask BQSR: steps A3 to A6

Steps A3 to A6 correspond to the process we name “triple mask BQSR” (Schlebusch et al. 2020, Breton et al. 2021)⁠ where BQSR stands for Base Quality Score Recalibration, a step which aims at calculating more accurate quality scores than those outputed by the sequencing machine. Briefly, instead of using only the standard reference dataset dbSNP to train the model, we first call variants for the specific individual and use the resulting VCF to train the model. GATK/3.5, samtools/1.1, picard/1.126, GATK/3.5, vcftools/0.1.13, tabix/0.2.6 and dbSNP144 were used throughout these steps.

From this step onward, only the autosomes (inclunding the "unknown" and "random" contigs) and chromosome X are considered.

We start by calling variants on the output of step A2; to that end, we first merge the different BAM files for each sample. This results in a first sample-specific VCF file. This is done in [step_A.3_variant-calling.sh](step_A.3_variant-calling.sh).

In parallel, we perform a standard BQSR (by lane) on the output of step A2: [step_A.4_dbsnp-BQSR.sh](step_A.4_dbsnp-BQSR.sh). In step A5, we merge the resulting BAM and call variants (same procedure as in A3); we obtain a second sample-specific VCF file. This is done in [Create step_A.5_variant-calling.sh](Create step_A.5_variant-calling.sh).

Finally, we proceed with the “triple mask BQSR” (by lane, step A6) on the output of step A2; we provide the two VCF files as known sites, together with dbSNP: [step_A.6_triple-mask-BQSR.sh](step_A.6_triple-mask-BQSR.sh).

## Processing by sample: steps A7 to A9

In steps A7 to A9, we prepare a final BAM file for each sample:

- in step A7, the outputs (by lane) of step A6 are merged and sorted: [step_A.7_merge-and-sort.sh](step_A.7_merge-and-sort.sh)
- in step A8, duplicates are marked: [step_A.8_mark-duplicates.sh](step_A.8_mark-duplicates.sh)
- and in step A9, indels are realigned: [step_A.9_indel-realignment.sh](step_A.9_indel-realignment.sh)

## Variant calling: steps A10 to A12

The next three steps are the variant calling steps and concern only the autosomes, which are selected with a new interval list file. We use GATK/3.7. Variant calling is decomposed in three steps:

- First, variants are called in each individual, resulting in a GVCF file (step A10). We use the variant caller HaplotypeCaller in genotyping mode `DISCOVERY` and with the option `emitRefConfidence BP_RESOLUTION`. As we want to obtain a final VCF with information about all sites we do not use the option recommended by GATK Best Practices – `emitRefConfidence GVCF` - where information is condensed in “blocks” for the non-variable positions. We use tabix/0.2.6 to bgzip and index the output. This is done in [step_A.10_variant-calling.sh](step_A.10_variant-calling.sh).
- The second step (A11) is to use the tool CombineGVCF to obtain multi-sample GVCF files. This speeds up the following step (joint genotyping). We found that combining the 49 individuals from the central African dataset; the 25 individuals from the southern African dataset with the 24 SAHGP individuals; and the 81 remaining comparative individuals, allowed for a reasonably fast joint genotyping step. This is done in [step_A.11_combine-GVCF.sh](step_A.11_combine-GVCF.sh).
- Finally, the third and last step (A12) is to jointly genotype all individuals with GenotypeGVCF: [step_A.12_joint-genotyping.sh](step_A.12_joint-genotyping.sh).

## Callset refinement: steps A13 to A15

### VQSR

GATK's Variant Quality Score Recalibration (VQSR) step recalibrates variant quality scores and produces a filtered callset. It is preferred to hard filtering. After building a recalibration model with VariantRecalibrator, the user chooses a threshold – called “tranche level” - for the filtering of the callset (performed with ApplyRecalibration). The higher that threshold, the more false positives the callset might contain. For the SNPs we chose a tranche level of 99.9 and for the indels of 99.0.

We performed the SNP VQSR first: step A13, [step_A.13_SNP-VQSR.sh](step_A.13_SNP-VQSR.sh).

Then we used the output of step A13 to perform the indel VQSR: step A14, [step_A.14_indel-VQSR.sh](step_A.14_indel-VQSR.sh).

### Additional filtering

**At which stage do we remove the two related individuals?**

We used vcftools “--missing-site” to calculate missingness per site and vcftools “--hardy” to test for Hardy Weinberg equilibrium (HWE). We then changed the filter field in the VCF for: sites with a 'N' in the reference genome (to FAIL1_N); sites with more than 10% missingness (to FAIL2_M); and sites heterozygous in all individuals (to FAIL3_H) - using bash and awk commands. HWE-filtering at population-level is hindered by the small sample sizes. Finally, we modified the VCF header to include information about the new filter flags we introduced.

We used GATK SelectVariants with option “trimAlternates” to restrict our callset to the variation present in the 177 unrelated individuals (while keeping all sites – we are only modifying the variant positions). We checked that running this step on the output of the preceding step was equivalent to using the tag “trimAlternates” at the step where the two related individuals are removed. We note that the sites which were variable in the total callset (179 individuals) and are not variable in the unrelated callset (177 individuals) appear as variable sites with “.” as alternate allele. It is not possible to make these entries look like usual non-variable sites using GATK tools (unless running GenotypeGVCF again without the two related individuals). This is a potential issue for downstream tools, as these sites might be counted as biallelic SNP monomorphic in the callset, even if all individuals are homozygous reference. It is thus important to keep track of how different tools treat these sites. We also noticed that the description of our custom filters in the header of the VCF disappears each time we run a new GATK column. The information is added back with a bash command (Appendix {SM:appendix}).


# End of processing chromosome X

For the start of the processing, see steps A1 to A9.

## StepX1

## StepX2

## StepX3

## StepX4

## StepX5

# Processing chromosome Y

# Processing mitochondria


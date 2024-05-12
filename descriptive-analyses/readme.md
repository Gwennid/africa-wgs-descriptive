This folder contains information on the descriptive analyses.

## Variant counts

Input: VQSRed, relatedness, site missingness 10%, HWE filter. Autosomes.

Use [variant_counts.sh](variant_counts.sh), then [sed_old_new_ind_ID.sh](sed_old_new_ind_ID.sh), then [variant_counts_by_pop.R](variant_counts_by_pop.R) (which requires [25KSP_49PNP_105comp_info.txt](25KSP_49PNP_105comp_info.txt)).

Outputs are in [results/variant-counts](../results/variant-counts).

## Heterozyosity

Input: VQSRed, relatedness, site missingness 10%, HWE filter (autosomes). VQSRed, relatedness, site missingness 10%, PAR regions excluded (X chromosome).

See [heterozygosity](heterozygosity).

## Select autosomal biallelic SNPs

VCFs with autosomal biallelic SNPs are obtained with GATK version 3.7:

```
java -Xmx6g -jar $GATK_HOME/GenomeAnalysisTK.jar -T SelectVariants -R ${ref} -V ${infile} -L chr${chrom} -selectType SNP -restrictAllelesTo BIALLELIC --excludeFiltered -o ${out}
```
They are converted to TPED and then plink binary fileset with VCFtools version 0.1.13 and plink version 1.90b4.9:
```
vcftools --gzvcf ${file}.vcf.gz --plink-tped --out ${file}
plink --tfile ${file} --make-bed --out ${file}
```

## Runs of homozygosity

Input: VQSRed, relatedness, site missingness 10%, HWE filter, biallelic SNPs with status "PASS" (autosomes).

Runs of homozygosity (ROH) were called in the callset of 177 individuals, using autosomal biallelic SNPs passing all filters (VQSR, relatedness, HWE and site missingness). We used plink (version 1.90b4.9) and the following tool:

```
plink
  --bfile /path/to/callset
  --homozyg
  --homozyg-density 20
  --homozyg-gap 50
  --homozyg-kb 200
  --homozyg-snp 200
  --homozyg-window-het 1
  --homozyg-window-snp 50
  --homozyg-window-threshold 0.05
  --out outprefix
```
See [results/ROH](../results/ROH) for the output and how it was summarized prior to plotting.

## ASD and MDS

Input: VQSRed, relatedness, site missingness 10%, HWE filter, biallelic SNPs with status "PASS", LD filter (autosomes).

We computed the ASD matrix with the [asd](https://github.com/szpiech/asd/tree/master) version 1.0 software. Prior to that, the data was filtered for LD with `plink --indep-pairwise 50 5 0.1`.

```
asd --tped ${prefix}.tped --tfam ${prefix}.tfam --out ${prefix} --biallelic
```

## ADMIXTURE

Input: VQSRed, relatedness, site missingness 10%, HWE filter, biallelic SNPs with status "PASS", LD filter, minor allele frequency filter (greater than 0.1) (autosomes).

Version: 1.3.0

```
admixture /path/to/25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.indeppairwise_50_5_0.1.maf0.1.bed $k -s $RANDOM

```

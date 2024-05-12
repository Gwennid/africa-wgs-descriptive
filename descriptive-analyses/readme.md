This folder contains information on the descriptive analyses.

## Variant counts

Use [variant_counts.sh](variant_counts.sh), then [sed_old_new_ind_ID.sh](sed_old_new_ind_ID.sh), then [variant_counts_by_pop.R](variant_counts_by_pop.R) (which requires [25KSP_49PNP_105comp_info.txt](25KSP_49PNP_105comp_info.txt)).

Outputs are in [results/variant-counts](../results/variant-counts).

## Heterozyosity

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

## ASD and MDS

We computed the ASD matrix with the `asd` software. Prior to that, the data was filtered for LD. (`plink --indep-pairwise 50 5 0.1`)

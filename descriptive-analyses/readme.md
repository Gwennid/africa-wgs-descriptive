This folder contains information on the descriptive analyses.

## Variant counts

Use variant_counts.sh, then sed_old_new_ind_ID.sh, then variant_counts_by_pop.R (which requires 25KSP_49PNP_105comp_info.txt).

Outputs are in africa-wgs-abc/results/variant-counts

## Heterozyosity

See the `heterozygosity` folder.

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

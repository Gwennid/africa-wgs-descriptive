# Scripts for calculating heterozygosity

Expected heterozygosity is calculated for each population for the autosomes and for the X chromosome separately.

First the different configurations are counted (for example, how many positions are homozygous reference). Non-variable positions are also counted.

Then, the counts of these configurations are summarized and used to calculate heterozygosity.

The last step is to calculate the X to autosome heterozygosity ratio.

We noticed that the samples from the HGDP dataset are quite different from the rest, so we analysed the population samples with a HGDP sample with and without the HGDP sample (e.g. Dai Chinese). We included only population samples with at least two genomes. The list of populations is: Baka Nzime BaKola Ngumba AkaMbati BaKiga BaTwa Nsua BaKonjo Karretjiepeople GuiandGana Juhoansi Nama Xun BantuHerero BantuKenya BantuTswana Biaka Dinka Esan Gambian Igbo Juhoansi_comp Khomani Lemande Luhya Luo Mandenka Maasai Mbuti Mende Mozabite Saharawi Yoruba DaiChinese Karitiana Papuan French CEU Coloured SothoSpeakers XhosaSpeakers Dinka_noHGDP Juhoansi_comp_noHGDP Mandenka_noHGDP Mbuti_noHGDP Yoruba_noHGDP French_noHGDP Papuan_noHGDP Karitiana_noHGDP DaiChinese_noHGDP

## Input autosomes

Input: VQSRed, relatedness, site missingness and HWE filtered

Current location on the cluster: `/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/25KS.48RHG.104comp.HCBP.chr.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.vcf.gz`

The code that I used previously, and corresponding results, is in: `/crex/proj/snic2020-2-10/uppstore2017183/b2012165/private/Seq_proj_cont/scripts/GATK_pipeline/analyses_from20181210/heterozygosity/bypop` (code and bash outputs) and `/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations` (counts).

Scripts and bash outputs from 2024 are in: `/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/bash_outputs/2024`

## Input X chromosome

Input: VQSRed, relatedness, site missingness filtered

Current location on the cluster: `/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/filtering_after_VQSR`

Compared to the autosomes, the PAR regions are excluded and there are more configurations (for females and males).

## Step 1: count the different configurations

This is done in each population and for each chromosome. There is a Python script for each population and each chromosome. For the autosomes, the template is [Het_calculations_bypop_bychr.py](Het_calculations_bypop_bychr.py), and you can generate all scripts with [allpop_1-22_generate_python_scripts.sh](allpop_1-22_generate_python_scripts.sh). These scripts are submitted via a bash script. They can either be run using the memory of the working node ("scratch"), for example [allpop_scratch_chr21.sh](allpop_scratch_chr21.sh), or running locally, for example [submit_chr2_noscratch.sh](submit_chr2_noscratch.sh). Chromosomes 5-6 and 9-22 were run in batch and using scratch. The other autosomes (1-4, 7-8) were not run on scratch, as it appeared that the decompression was incomplete on scratch, probably due to the size of the VCF (more than 600 GiG for chromosomes 1 and 2 for example).

For each chromosome and each population sample, the outputs are:

- chrchromosome_popname_count.txt: a summary of the number of sites of different kind
- chrchromosome_popname_bial_count_genotypes.txt: for each biallelic site, the count of homozygous reference/homozygous alternate/heterozygous genotypes in the sample
- chrchromosome_popname_trial_count_genotypes.txt: for each triallelic site, the count of each genotype in the sample

For an example, see [the results for chromosome 22 of the Nsua](../../results/heterozygosity/example_result).

The template for the X chromosome is [Het_calculations_bypop_X_PARremoved.py](Het_calculations_bypop_X_PARremoved.py), and scripts can be generated for all population samples with [allpop_X_generate_python_scripts.sh](allpop_X_generate_python_scripts.sh).

For each population sample, the outputs are:

- chrX_popname_count.txt: a summary of the number of sites of different kind
- chrX_popname_bial_count_genotypes.txt: for each biallelic site, the count of DIPLOID_HOM_REF HAPLOID_REF DIPLOID_HOM_ALT HAPLOID_ALT HET genotypes in the sample

For an example, see [the results for chromosome X of the Nsua](../../results/heterozygosity/example_result).

All outputs were placed in `/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations_2024/wrapup`

## Step 2: summarize the genotype configurations and compute heterozygosity

In order to calcualte heterozygosity, we need information about how many sites there are in total (variable and non-variable) and what the genotype configuration is at the variable sites.

First, for the biallelic sites in each chromosome and each population sample, a count table of the different genotype configurations is made, with [step3_postprocessing.sh](step3_postprocessing.sh). See example outputs for [chromosome 22](../../results/heterozygosity/example_result/chr22_Nsua_bial_count_genotypes_summary.txt) and [chromosome X](../../results/heterozygosity/example_result/chrX_PARremoved_Nsua_bial_count_genotypes_summary.txt).

Then, the summary tables for the biallelic sites genotype configurations, and the counts of all sites, are used to compute different estimates of heterozygosity in [step4_postprocessing.R](step4_postprocessing.R). Results are [here](../../results/heterozygosity).

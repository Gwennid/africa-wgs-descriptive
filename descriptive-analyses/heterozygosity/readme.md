# Scripts for calculating heterozygosity

Expected heterozygosity is calculated for each population for the autosomes and for the X chromosome separately.

First the different configurations are counted (for example, how many positions are homozygous reference). Non-variable positions are also counted.

Then, the counts of these configurations are summarized and used to calculate heterozygosity.

The last step is to calculate the X to autosome heterozygosity ratio.

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

The template for the X chromosome is [Het_calculations_bypop_X_PARremoved.py](Het_calculations_bypop_X_PARremoved.py), and scripts can be generated for all population samples with [allpop_X_generate_python_scripts.sh](allpop_X_generate_python_scripts.sh).

We noticed that the samples from the HGDP dataset are quite different from the rest, so we analysed the population samples with a HGDP sample with and without the HGDP sample (e.g. Dai Chinese). We included only population samples with at least two genomes. The list of populations is: Baka Nzime BaKola Ngumba AkaMbati BaKiga BaTwa Nsua BaKonjo Karretjiepeople GuiandGana Juhoansi Nama Xun BantuHerero BantuKenya BantuTswana Biaka Dinka Esan Gambian Igbo Juhoansi_comp Khomani Lemande Luhya Luo Mandenka Maasai Mbuti Mende Mozabite Saharawi Yoruba DaiChinese Karitiana Papuan French CEU Coloured SothoSpeakers XhosaSpeakers Dinka_noHGDP Juhoansi_comp_noHGDP Mandenka_noHGDP Mbuti_noHGDP Yoruba_noHGDP French_noHGDP Papuan_noHGDP Karitiana_noHGDP DaiChinese_noHGDP

All outputs were placed in `/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations_2024/wrapup`

## Step 2: put together the results from all chromosomes and all populations




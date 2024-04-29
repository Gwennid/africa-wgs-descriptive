# Scripts for calculating heterozygosity

Expected heterozygosity is calculated for each population for the autosomes and for the X chromosome separately.

First the different configurations are counted (for example, how many positions are homozygous reference). I also count non-variable positions.

Then, the counts of these configurations are summarized and used to calculate heterozygosity.

The last step is to calculate the X to autosome heterozygosity ratio.

## Input autosomes

Start from `/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/25KS.48RHG.104comp.HCBP.chr.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.vcf.gz` (?)

The code that I used previously, and corresponding results, is in: `/crex/proj/snic2020-2-10/uppstore2017183/b2012165/private/Seq_proj_cont/scripts/GATK_pipeline/analyses_from20181210/heterozygosity/bypop` (code and bash outputs) and `/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations` (counts).

Scripts and bash outputs from 2024 are in: `/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/bash_outputs/2024`

## Input X chromosome

The PAR region is removed. **TODO Elaborate**

Start from `/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/Gwenna_Xchr/filtering_after_VQSR`

## Step 1: count the different configurations

This is done in each population and for each chromosome. There is a Python script for each population and each chromosome. The template is `Het_calculations_bypop_bychr.py`, and you can generate all scripts with `allpop_1-22_generate_python_scripts.sh`. These scripts are submitted via a bash script, for example `allpop_scratch_chr19.sh`. Chromosomes 5-6 and 9-22 were run in batch and using scratch. The other autosomes (1-4, 7-8) were not run on scratch, as it appeared that the decompression was incomplete on scratch, probably due to the size of the VCF (more than 600 GiG for chromosomes 1 and 2 for example).

All outputs were placed in `/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations_2024/wrapup`

## Step 2: put together the results from all chromosomes and all populations

xxx

The list of populations is: Baka Nzime BaKola Ngumba AkaMbati BaKiga BaTwa Nsua BaKonjo Karretjiepeople GuiandGana Juhoansi Nama Xun BantuHerero BantuKenya BantuTswana Biaka Dinka Esan Gambian Igbo Juhoansi_comp Khomani Lemande Luhya Luo Mandenka Maasai Mbuti Mende Mozabite Saharawi Yoruba DaiChinese Karitiana Papuan French CEU Coloured SothoSpeakers XhosaSpeakers Dinka_noHGDP Juhoansi_comp_noHGDP Mandenka_noHGDP Mbuti_noHGDP Yoruba_noHGDP French_noHGDP Papuan_noHGDP Karitiana_noHGDP. Note that we included "noHGDP" sets, as previous observations suggest some biases in the HGPD samples.

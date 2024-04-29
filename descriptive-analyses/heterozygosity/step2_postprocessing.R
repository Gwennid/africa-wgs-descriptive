# 2024-03-07
# Gwenna Breton
# Goal: compute heterozygosity in each population step based on the counts of the different configurations calculated at step 1
#Based on compute_pop_het.R

#The following is run in a screen, as an interactive job.
#R version 3.6.0
setwd("/crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations_2024/wrapup")

##### AUTOSOMES #####

##### 
## For each population, calculate the % of missing sites for the NOVAR sites (NOVAR in the dataset) and the % of missing sites for the BIAL sites (BIAL in the dataset).
#Hypothesis: will vary with average coverage in the population.
#####
write.table(file="allchr_pop_count_summary.txt",t(c("CHR","POPNAME","tot_novar","tot_bial","bial_in_pop","prop_missing_novar","prop_missing_bial")),col.names = FALSE,row.names = FALSE)
for (CHR in c(1:22)) {
  for (POPNAME in c("Baka","Nzime","BaKola","Ngumba","AkaMbati","BaKiga","BaTwa","Nsua","BaKonjo","Karretjiepeople","GuiandGana","Juhoansi","Nama","Xun","BantuHerero",
                    "BantuKenya","BantuTswana","Biaka","Dinka","Esan","Gambian","Igbo","Juhoansi_comp","Khomani","Lemande","Luhya","Luo","Mandenka","Maasai","Mbuti",
                    "Mende","Mozabite","Saharawi","Yoruba","DaiChinese","Karitiana","Papuan","French","CEU","Coloured","SothoSpeakers","XhosaSpeakers")) {
    count = read.table(file=paste("chr",CHR,"_",POPNAME,"_count.txt",sep=""))
    tot_novar = sum(count[1:2,2])
    tot_bial = sum(count[3:6,2])
    bial_in_pop = count[6,2]
    prop_missing_novar = count[1,2]/tot_novar
    prop_missing_bial = count[3,2]/tot_bial
    write.table(file="allchr_pop_count_summary.txt",append=TRUE,t(c(CHR,POPNAME,tot_novar,tot_bial,bial_in_pop,prop_missing_novar,prop_missing_bial)),col.names = FALSE,row.names = FALSE)
  }
}

#Do the same for the population sets excluding the HGDP samples
write.table(file="allchr_pop_noHGDP_count_summary.txt",t(c("CHR","POPNAME","tot_novar","tot_bial","bial_in_pop","prop_missing_novar","prop_missing_bial")),col.names = FALSE,row.names = FALSE)
for (CHR in c(1:22)) {
  for (POPNAME in c("Juhoansi_comp_noHGDP","Dinka_noHGDP","French_noHGDP","Papuan_noHGDP","Yoruba_noHGDP","Mbuti_noHGDP","Mandenka_noHGDP","Karitiana_noHGDP","DaiChinese_noHGDP")) {
    count = read.table(file=paste("chr",CHR,"_",POPNAME,"_count.txt",sep=""))
    tot_novar = sum(count[1:2,2])
    tot_bial = sum(count[3:6,2])
    bial_in_pop = count[6,2]
    prop_missing_novar = count[1,2]/tot_novar
    prop_missing_bial = count[3,2]/tot_bial
    write.table(file="allchr_pop_noHGDP_count_summary.txt",append=TRUE,t(c(CHR,POPNAME,tot_novar,tot_bial,bial_in_pop,prop_missing_novar,prop_missing_bial)),col.names = FALSE,row.names = FALSE)
  }
}

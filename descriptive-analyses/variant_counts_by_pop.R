# 2023-07-05
# Gwenna Breton
# Goal: summarize variant counts information by populations. Should be run on outputs from variant_counts.sh
#Based on /Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/sequence_processing/scripts/mapping_and_GATK_final_scripts/HC_BPresolution/countvariants/20200604_summarize_indcounts_bypop.R

#Preliminary: individual ID were updated to more explicit names in file 25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_detail_metrics.AVG using the script africa-wgs-abc/descriptive-analyses/sed_old_new_ind_ID.sh 
#I also added "ID" at the start of the first row, so that the header has as many elements as the number of columns.

##Read in the information
setwd("/Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/africa-wgs-abc/results/variant-counts")
counts <- read.table("25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.dbsnp156.some_detail_metrics.AVG_newnames",header=TRUE)

##Add information about population etc
info <- read.table(file="../../descriptive-analyses/25KSP_49PNP_105comp_info.txt",header=TRUE)

counts2 <- counts[1:177,]
info2 <- info[info$ID != "PNP061",]
info3 <- info2[info2$ID != "SGDPJUH2",]

##Ensure the same order
counts2r <- counts2[order(match(counts2[,1],info3[,1])),]

POP <- c("ba.kiga","ba.kola","ba.konjo","ba.twa","baka","bantuh","bantuk","bantut","biaka","biakambati","ceu","coloured","dai",
         "dinka","esan","french","gambian","guigana","igbo","juhoansi","juhoansi_comp","karitiana","karretjie","khomani","kongo","lemande","luhya","luo",
         "maasai","mandenka","mandinka","mbuti","mende","mozabite","nama","ngumba","nsua","nzime","papuan","saharawi","somali","sotho",
         "xhosa","xun","yoruba","zulu")

# mat <- matrix(0,length(POP),9)
# 
# for (i in (1:length(POP))) {
#   pop <- POP[i]
#   snp_mean <- mean(counts2r$TOTALSNP[info3$POP==pop])
#   snp_sd <- sd(counts2r$TOTALSNP[info3$POP==pop])
#   cov_mean <- mean(info3$COVERAGE[info3$POP==pop])
#   cov_sd <- sd(info3$COVERAGE[info3$POP==pop])
#   novel_mean <- mean(counts2r$TOTALSNP[info3$POP==pop]-counts2r$NUM_IN_DB_SNP[info3$POP==pop])
#   novel_sd <- sd(counts2r$TOTALSNP[info3$POP==pop]-counts2r$NUM_IN_DB_SNP[info3$POP==pop])
#   indel_mean <- mean(counts2r$TOTALINDEL[info3$POP==pop])
#   indel_sd <- sd(counts2r$TOTALINDEL[info3$POP==pop])
#   mat[i,] <- c(pop,round(snp_mean),round(snp_sd),round(novel_mean),round(novel_sd),round(indel_mean),round(indel_sd),round(cov_mean,1),round(cov_sd,1))
# }
# 
# write.table(file="25KS.48RHG.104comp.allfilters.summarybypop",mat,
#             col.names = c("POP","TOTALSNP_mean","TOTALSNP_sd","NOVELSNP_mean","NOVELSNP_sd","TOTALINDEL_mean","TOTALINDEL_sd","COV_mean","COV_sd"),
#             row.names=FALSE)
# #Comment: the standard deviation for groups with a single individual is NA.

#####QUESTION
##There is more code to get mean coverage by dataset. Do I need that?
#####

#####
# Plot the number of biallelic SNPs by population (boxplots)
#####

#Make a single dataframe so it's easier to manipulate
data <- data.frame(counts2r, info3)

#Order by increasing median of "TOTALSNP" (i.e. biallelic SNP by individual)
new_order <- with(data, reorder(data$POP, data$TOTALSNP, median , na.rm=T))
boxplot(data$TOTALSNP ~ new_order , ylab="Number of biallelic SNPs" , col="#69b3a2", boxwex=0.4 , main="")

#Subset the original data frame to our populations and do the same (= order by increasing median)
data_KSP_PNP <- subset.data.frame(data, data$DATASET=="PNP" | data$DATASET=="KSP")
new_order_KSP_PNP <- with(data_KSP_PNP, reorder(data_KSP_PNP$POP, data_KSP_PNP$TOTALSNP, median , na.rm=T))

pdf(file="../../results/variant-counts/biallelic_snps_by_pop_KSP-PNP.pdf",height=5,width=10,pointsize = 12)
par(cex.axis=1) #This is for the name of the labels (on the x and on the y axes)
par(cex.lab=1) #This is for the name of the axis (e.g. "Number of biallelic SNPs")
par(mar=c(7.5, 4, 2, 2) + 0.1) #Default: c(5, 4, 4, 2) + 0.1 - c(bottom, left, top, right)
boxplot(data_KSP_PNP$TOTALSNP ~ new_order_KSP_PNP, ylab="Number of biallelic SNPs" ,
        col=c(rep("chocolate",4),rep("chartreuse",5),rep("slateblue4",5)), boxwex=0.4, main="", xlab = "",
        names = c("Ba.Kiga","Ba.Konjo","Nzime","Ngumba","Ba.Twa","Ba.Kola","Nsua","Baka","Bi.Aka Mbati","Nama","Karretjie People","Khutse San","!Xun","Ju|'hoansi"),
        las = 3)
dev.off()

#Next:
# - replace by proper population names
#c("Ba.Kiga","Ba.Konjo","Nzime","Ngumba","Ba.Twa","Ba.Kola","Nsua","Baka","Bi.Aka Mbati","Nama","Karretjie People","Khutse San","!Xun","Ju|'hoansi")
# - write the population names smaller so that they fit
# - color code by RHG/RHGn/KS. Do I have these broad categories somewhere?
#"slateblue4" = Juhoansi, "chartreuse" = Baka, "chocolate" = Ngumba
# - show it to PV. Should I include a couple of comparative populations? 
#Color code? (Look together at the existing figures and decide) (I went for blue for KS, green 
#for RHG, red for RHGn) (he went for a different set for ABC models)
# - modify the ylim?





            


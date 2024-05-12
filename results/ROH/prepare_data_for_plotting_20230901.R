# 2023-09-01
# Gwenna Breton
# Goal: summarize the ROH information by pop and by length class for plotting.
#This is based on code in 20200515_plotROH.R. Compared to it, I modified the result file to distinguish between Juhoansi and Juhoansi_comp (cf commands_reformat_20230901.sh).
#2023-12-05: doing it again with the Mandenka and the Mandinka separated.

setwd("/Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/writing/ms/ongoing/Figures/Figure_ROH/")
#data1 <- read.table(file="25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.homNEWNAMES.45pop",header=TRUE)
data1 <- read.table(file = "25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.homNEWNAMES.46pop", header=TRUE)

#0.2-0.5Mbp
cat_all <- data1[(data1$KB >= 200) & (data1$KB <= 500), ]
cat_all_tmpp   <- split(cat_all$KB, cat_all$IID)
cat_all_sumind <- sapply(cat_all_tmpp, sum)
write.table (cat_all_sumind, file = "xx", quote = FALSE, col.names = FALSE)
cat_all_sumindd <- read.table ("xx")
cat_all_sumindd[,3] <-data1$FID[match(cat_all_sumindd[,1], data1$IID)]
cat_all_sumindd1<-cat_all_sumindd[cat_all_sumindd[,2]>0, ]
cat_all_tmpp   <- split(cat_all_sumindd1[,2], cat_all_sumindd1[,3])
cat_all_imeans2 <- sapply(cat_all_tmpp, mean)
cat_all_imeans3 <-cat_all_imeans2/1000
#write.table(cat_all_imeans3, file = "25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.45pop.0.2to0.5Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)
write.table(cat_all_imeans3, file = "25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.46pop.0.2to0.5Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)

#0.5-1Mbp
cat_all <- data1[(data1$KB >= 500) & (data1$KB <= 1000), ]
cat_all_tmpp   <- split(cat_all$KB, cat_all$IID)
cat_all_sumind <- sapply(cat_all_tmpp, sum)
write.table (cat_all_sumind, file = "xx", quote = FALSE, col.names = FALSE)
cat_all_sumindd <- read.table ("xx")
cat_all_sumindd[,3] <-data1$FID[match(cat_all_sumindd[,1], data1$IID)]
cat_all_sumindd1<-cat_all_sumindd[cat_all_sumindd[,2]>0, ]
cat_all_tmpp   <- split(cat_all_sumindd1[,2], cat_all_sumindd1[,3])
cat_all_imeans2 <- sapply(cat_all_tmpp, mean)
cat_all_imeans3 <-cat_all_imeans2/1000
#write.table(cat_all_imeans3, file = "25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.45pop.0.5to1Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)
write.table(cat_all_imeans3, file = "25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.46pop.0.5to1Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)

#1-2 Mbp
cat_all1_2 <- data1[(data1$KB >= 1000) & (data1$KB <= 2000), ]
cat_all1_2_tmpp   <- split(cat_all1_2$KB, cat_all1_2$IID)
cat_all1_2_sumind <- sapply(cat_all1_2_tmpp, sum)
write.table (cat_all1_2_sumind, file = "xx1_2", quote = FALSE, col.names = FALSE)
cat_all1_2_sumindd <- read.table ("xx1_2")
cat_all1_2_sumindd[,3] <-data1$FID[match(cat_all1_2_sumindd[,1], data1$IID)]
cat_all1_2_sumindd1<-cat_all1_2_sumindd[cat_all1_2_sumindd[,2]>0, ]
cat_all1_2_tmpp   <- split(cat_all1_2_sumindd1[,2], cat_all1_2_sumindd1[,3])
cat_all1_2_imeans2 <- sapply(cat_all1_2_tmpp, mean)
cat_all1_2_imeans3 <-cat_all1_2_imeans2/1000
#write.table(cat_all1_2_imeans3, file = "25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.45pop.1to2Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)
write.table(cat_all1_2_imeans3, file = "25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.46pop.1to2Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)

#2-4 Mbp
cat_all2_andmore <- data1[(data1$KB >= 2000) & (data1$KB <= 4000), ]
cat_all2_andmore_tmpp   <- split(cat_all2_andmore$KB, cat_all2_andmore$IID)
cat_all2_andmore_sumind <- sapply(cat_all2_andmore_tmpp, sum)
write.table (cat_all2_andmore_sumind, file = "xx2_andmore", quote = FALSE, col.names = FALSE)
cat_all2_andmore_sumindd <- read.table ("xx2_andmore")
cat_all2_andmore_sumindd[,3] <-data1$FID[match(cat_all2_andmore_sumindd[,1], data1$IID)]
cat_all2_andmore_sumindd1<-cat_all2_andmore_sumindd[cat_all2_andmore_sumindd[,2]>0, ]
cat_all2_andmore_tmpp   <- split(cat_all2_andmore_sumindd1[,2], cat_all2_andmore_sumindd1[,3])
cat_all2_andmore_imeans2 <- sapply(cat_all2_andmore_tmpp, mean)
cat_all2_andmore_imeans3 <-cat_all2_andmore_imeans2/1000
#write.table(cat_all2_andmore_imeans3, file = "25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.45pop.2to4Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)
write.table(cat_all2_andmore_imeans3, file = "25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.46pop.2to4Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)
#Obs! I added manually "POP NA" for each of the populations for which there is no ROH in that length class.

#More than 4 Mbp
cat_all2_andmore <- data1[(data1$KB >= 4000), ]
cat_all2_andmore_tmpp   <- split(cat_all2_andmore$KB, cat_all2_andmore$IID)
cat_all2_andmore_sumind <- sapply(cat_all2_andmore_tmpp, sum)
write.table (cat_all2_andmore_sumind, file = "xx2_andmore", quote = FALSE, col.names = FALSE)
cat_all2_andmore_sumindd <- read.table ("xx2_andmore")
cat_all2_andmore_sumindd[,3] <-data1$FID[match(cat_all2_andmore_sumindd[,1], data1$IID)]
cat_all2_andmore_sumindd1<-cat_all2_andmore_sumindd[cat_all2_andmore_sumindd[,2]>0, ]
cat_all2_andmore_tmpp   <- split(cat_all2_andmore_sumindd1[,2], cat_all2_andmore_sumindd1[,3])
cat_all2_andmore_imeans2 <- sapply(cat_all2_andmore_tmpp, mean)
cat_all2_andmore_imeans3 <-cat_all2_andmore_imeans2/1000
#write.table(cat_all2_andmore_imeans3, file = "25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.45pop.morethan4Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)
write.table(cat_all2_andmore_imeans3, file = "25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.46pop.morethan4Mbp_means", sep = " ", col.names = FALSE, quote = FALSE)
#Obs! I added manually "POP NA" for each of the populations for which there is no ROH in that length class.
#The order of the populations is not the same like in the other files. I'm not plotting this class so it doesn't matter.


# 2024-12-05
# Gwenna Breton
# Goal: test the significance of differences in descriptors of diversity (heterozygosity, variant counts, ROH).

setwd("/Users/gwennabreton/Documents/Research/Previous_work/PhD_work/P2_RHG_KS/africa-wgs-descriptive/descriptive-analyses/")

## Data
het <- read.table(file="/Users/gwennabreton/Documents/Research/Previous_work/PhD_work/P2_RHG_KS/africa-wgs-descriptive/results/heterozygosity/allchr_42pop_Het_obs_exp_bialsites.txt", header=TRUE)
#The variable that is plotted in Fig. 2B is H_E_UNBIASED_ALLSITES

# 2026-01-16 I don't understand what the point of the rows below is. I am changing "het2" to "het" in the tests.
# pop <- read.table(file="/Users/gwennabreton/Documents/Research/Previous_work/PhD_work/P2_RHG_KS/africa-wgs-descriptive/results/helper_files/info_pop_for_plotting.txt",header = TRUE, sep="\t", quote="\"", comment.char="")
# a <- match(het$POPNAME, pop$POPNAMEHET)
# het2 <- data.frame(het, pop[a,])

## Test

###
### “western RHG populations exhibited much larger genetic diversities then all their respective RHG neighbors”
###

# Baka He greater than Nzime He
#Does it make sense to use the chromosomes as a vector?
wilcox.test(het[het$POPNAME=="Baka",]$H_E_UNBIASED_ALLSITES, het[het$POPNAME=="Nzime",]$H_E_UNBIASED_ALLSITES, "greater")
#The het in Baka are not significantly greater than in Nzime
#W = 302, p-value = 0.08204
#alternative hypothesis: true location shift is greater than 0

# Ba.Kola He greater than Ngumba He
wilcox.test(het[het$POPNAME=="BaKola",]$H_E_UNBIASED_ALLSITES, het[het$POPNAME=="Ngumba",]$H_E_UNBIASED_ALLSITES, "greater")
#The het in BaKola are not significantly greater than in Ngumba
#W = 282, p-value = 0.1787
#alternative hypothesis: true location shift is greater than 0

# Baka + Ba.Kola combined greater than Nzime + Ngumba
group1 = het[het$POPNAME=="Baka" | het$POPNAME=="BaKola" ,]
group2 = het[het$POPNAME=="Nzime" | het$POPNAME=="Ngumba" ,]
wilcox.test(group1$H_E_UNBIASED_ALLSITES, group2$H_E_UNBIASED_ALLSITES, "greater")
# W = 1170, p-value = 0.04637

# more?

###
### “We find overall more variation in the RHG from the western part of the Congo Basin than in RHG populations from the east”
###
group1 = het[het$POPNAME=="Baka" | het$POPNAME=="BaKola" | het$POPNAME=="AkaMbati" ,]
group2 = het[het$POPNAME=="Nsua" | het$POPNAME=="BaTwa" ,]
wilcox.test(group1$H_E_UNBIASED_ALLSITES, group2$H_E_UNBIASED_ALLSITES, "greater")
#significant: the het in our wRHG populations is greater than in our eRHG populations.
#W = 1898, p-value = 0.003282
#alternative hypothesis: true location shift is greater than 0

#Can we use a t-test? (i.e. is the data normally distributed?)
shapiro.test(group1$H_E_UNBIASED_ALLSITES)
#p-value = 0.0002794
#No, the data is not normally distributed

#What if we include the Biaka and the Mbuti?
group1 = het[het$POPNAME=="Baka" | het$POPNAME=="BaKola" | het$POPNAME=="AkaMbati" | het$POPNAME=="Biaka" ,]
group2 = het[het$POPNAME=="Nsua" | het$POPNAME=="BaTwa" | het$POPNAME=="Mbuti" ,]
wilcox.test(group1$H_E_UNBIASED_ALLSITES, group2$H_E_UNBIASED_ALLSITES, "greater")
#The het in wRHG pop is greater than in the eRHG pop.
#W = 4042, p-value = 1.641e-05
#alternative hypothesis: true location shift is greater than 0

#Do we want to compare the variant counts too?

###
### “We find varying genetic variation across Northern Khoe-San populations (Xun and Juhoansi) and Southern KS populations (Nama, Karretjie People and Khomani).”
###

# nKS versus sKS, our populations only
group1 = het[het$POPNAME=="Xun" | het$POPNAME=="Juhoansi" ,]
group2 = het[het$POPNAME=="Nama" | het$POPNAME=="Karretjiepeople" ,]
wilcox.test(group1$H_E_UNBIASED_ALLSITES, group2$H_E_UNBIASED_ALLSITES, "two.sided")
# The two groups do not differ significantly.
#W = 1006, p-value = 0.7555
#alternative hypothesis: true location shift is not equal to 0

# nKS versus sKS, all populations
group1 = het[het$POPNAME=="Xun" | het$POPNAME=="Juhoansi" | het$POPNAME=="Juhoansi_comp" ,]
group2 = het[het$POPNAME=="Nama" | het$POPNAME=="Karretjiepeople" | het$POPNAME=="Khomani" ,]
wilcox.test(group1$H_E_UNBIASED_ALLSITES, group2$H_E_UNBIASED_ALLSITES, "two.sided")
# The two groups do not differ significantly.
#W = 2242, p-value = 0.7726
#alternative hypothesis: true location shift is not equal to 0

# within nKS (our populations)
wilcox.test(het[het$POPNAME=="Xun",]$H_E_UNBIASED_ALLSITES, het[het$POPNAME=="Juhoansi",]$H_E_UNBIASED_ALLSITES, "two.sided")
# The two populations do not differ significantly
#W = 306, p-value = 0.1372
#alternative hypothesis: true location shift is not equal to 0

# within sKS
wilcox.test(het[het$POPNAME=="Nama",]$H_E_UNBIASED_ALLSITES, het[het$POPNAME=="Karretjiepeople",]$H_E_UNBIASED_ALLSITES, "two.sided")
# W = 230, p-value = 0.7893

wilcox.test(het[het$POPNAME=="Nama",]$H_E_UNBIASED_ALLSITES, het[het$POPNAME=="Khomani",]$H_E_UNBIASED_ALLSITES, "two.sided")
# W = 307, p-value = 0.131

wilcox.test(het[het$POPNAME=="Khomani",]$H_E_UNBIASED_ALLSITES, het[het$POPNAME=="Karretjiepeople",]$H_E_UNBIASED_ALLSITES, "two.sided")
# W = 171, p-value = 0.09827

###
### ROH
###

ROH <- read.table(file="/Users/gwennabreton/Documents/Research/Previous_work/PhD_work/P2_RHG_KS/africa-wgs-descriptive/results/ROH/Sum_ROH_by_ind_by_bin.txt", header = TRUE)
#Obs! Here I have the values in kbp.

####
#### "Western RHG populations (Ba.Kola, Baka, Biaka, Bi.Aka_Mbati) have much less ROH of all classes than Eastern RHG"
###
group1 = ROH[ROH$POP=="Baka" | ROH$POP=="Ba.Kola" | ROH$POP=="Bi.Aka_Mbati" | ROH$POP=="Biaka" ,]
group2 = ROH[ROH$POP=="Nsua" | ROH$POP=="Mbuti" | ROH$POP=="Batwa" ,]

### Class 0.2-0.5
median(group1$X0.2.0.5) #Median WP: 46513.26 kbp (46.51326 Mbp)
median(group2$X0.2.0.5) #Median EP: 72284.26 kbp (72.28426 Mbp)
wilcox.test(group1$X0.2.0.5, group2$X0.2.0.5, "less")
# data:  group1$X0.2.0.5 and group2$X0.2.0.5
# W = 11, p-value = 4.803e-08
# alternative hypothesis: true location shift is less than 0
wilcox.test(group1$X0.2.0.5/1000, group2$X0.2.0.5/1000, "less")
# Same results

### Class 0.5-1
round(median(group1$X0.5.1)/1000,2) #Median WP: 23.91 Mbp
round(median(group2$X0.5.1)/1000,2) #Median EP: 35.98 Mbp
wilcox.test(group1$X0.5.1, group2$X0.5.1, "less")
# data:  group1$X0.5.1 and group2$X0.5.1
# W = 76, p-value = 0.005544
# alternative hypothesis: true location shift is less than 0

### Class 1-2
wilcox.test(group1$X1.2, group2$X1.2, "less")
# data:  group1$X1.2 and group2$X1.2
# W = 117, p-value = 0.1284
# alternative hypothesis: true location shift is less than 0

### Class 2-4
#Lots of NA in that length category.
wilcox.test(group1$X2.4, group2$X2.4, "less")
# data:  group1$X2.4 and group2$X2.4
# W = 28, p-value = 0.1577
# alternative hypothesis: true location shift is less than 0

####
#### "We find substantially more ROH of longer class in KS populations than in RHG neighbors, a relative pattern similar to what was observed for Western RHG."
####
group1 = ROH[ROH$POP=="Juhoansi_comp" | ROH$POP=="Juhoansi" | ROH$POP=="Karretjie" | ROH$POP=="Khutse_San" | ROH$POP=="Nama" | ROH$POP=="Xun",]
group2 = ROH[ROH$POP=="Nzime" | ROH$POP=="Ngumba" | ROH$POP=="Ba.Konjo" | ROH$POP=="Ba.Kiga" ,]

# Class 2-4
round(median(group1$X2.4, na.rm = TRUE)/1000,2) #Median KS: 2.73 Mbp
round(median(group2$X2.4, na.rm = TRUE)/1000,2) #Median RHGn: 2.42 Mbp
wilcox.test(group1$X2.4, group2$X2.4, "greater")
#data:  group1$X2.4 and group2$X2.4
#W = 40, p-value = 0.433
#alternative hypothesis: true location shift is greater than 0

# Class 1-2
round(median(group1$X1.2, na.rm = TRUE)/1000,2) #Median KS: 10.37 Mbp
round(median(group2$X1.2, na.rm = TRUE)/1000,2) #Median RHGn: 3.63 Mbp
wilcox.test(group1$X1.2, group2$X1.2, "greater")
# data:  group1$X1.2 and group2$X1.2
# W = 441, p-value = 3.71e-05
# alternative hypothesis: true location shift is greater than 0

####
#### "individuals from Eastern RHG populations (Nsua, Mbuti, Ba.Twa), exhibit the longest total proportion of their autosomal genome in ROH across Sub-Saharan African populations, for all ROH length-classes, with the exception of #Khomani individuals from Southern Africa, and that of Coloured individuals for short ROH only"
####
# How should we test that? group1 = eRHG, group 2 = the rest (minus Khomani and Coloured) ?

####
#### "less short ROH, but more long ROH, in Western RHG than in all RHG neighboring populations across the Congo Basin except for the Ba.Kiga RHGn from Uganda"
####

group1 = ROH[ROH$POP=="Baka" | ROH$POP=="Ba.Kola" | ROH$POP=="Bi.Aka_Mbati" | ROH$POP=="Biaka" ,]
group2 = ROH[ROH$POP=="Nzime" | ROH$POP=="Ngumba" | ROH$POP=="Ba.Konjo" ,]

### Class 0.2-0.5
round(median(group1$X0.2.0.5,na.rm=TRUE)/1000,2) #Median WP: 46.51 Mbp
round(median(group2$X0.2.0.5,na.rm=TRUE)/1000,2) #Median RHGn: 58.13 Mbp
wilcox.test(group1$X0.2.0.5, group2$X0.2.0.5, "less")
# data:  group1$X0.2.0.5 and group2$X0.2.0.5
# W = 30, p-value = 1.424e-05

### Class 0.5-1
round(median(group1$X0.5.1,na.rm=TRUE)/1000,2) #Median WP: 23.91 Mbp
round(median(group2$X0.5.1,na.rm=TRUE)/1000,2) #Median RHGn: 14.59 Mbp
wilcox.test(group1$X0.5.1, group2$X0.5.1, "greater")
# data:  group1$X0.5.1 and group2$X0.5.1
# W = 237, p-value = 0.000336

### Class 1-2
round(median(group1$X1.2,na.rm=TRUE)/1000,2) #Median WP: 11.96 Mbp
round(median(group2$X1.2,na.rm=TRUE)/1000,2) #Median RHGn: 3.24 Mbp
wilcox.test(group1$X1.2, group2$X1.2, "greater")
# data:  group1$X1.2 and group2$X1.2
# W = 255, p-value = 2.382e-07

# I could redo the same tests and include the Ba.Kiga and see what happens. Are tests no longer significant?

####
#### "all Northern and Southern Khoe-San populations have relatively similar total lengths of short ROH compared to that of RHG neighbors, with the notable exception of the !Xun, who have the smallest proportion of their genomes in short ROH, worldwide"
####

group1 = ROH[ROH$POP=="Juhoansi_comp" | ROH$POP=="Juhoansi" | ROH$POP=="Karretjie" | ROH$POP=="Khutse_San" | ROH$POP=="Nama" ,]
group2 = ROH[ROH$POP=="Nzime" | ROH$POP=="Ngumba" | ROH$POP=="Ba.Konjo" | ROH$POP=="Ba.Kiga" ,]

# Class 0.2-0.5
round(median(group1$X0.2.0.5, na.rm = TRUE)/1000,2) #Median KS: 62.08 Mbp
round(median(group2$X0.2.0.5, na.rm = TRUE)/1000,2) #Median RHGn: 58.02 Mbp
wilcox.test(group1$X0.2.0.5, group2$X0.2.0.5)
# data:  group1$X0.2.0.5 and group2$X0.2.0.5
# W = 341, p-value = 0.01675
# It is significant.


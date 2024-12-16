# 2024-12-05
# Gwenna Breton
# Goal: test the significance of differences in descriptors of diversity (heterozygosity, variant counts, ROH).

setwd("/Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/africa-wgs-descriptive/descriptive-analyses/")

## Data
het <- read.table(file="/Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/africa-wgs-descriptive/results/heterozygosity/allchr_42pop_Het_obs_exp_bialsites.txt", header=TRUE)
#The variable that is plotted in Fig. 2B is H_E_UNBIASED_ALLSITES

pop <- read.table(file="/Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/africa-wgs-descriptive/results/helper_files//info_pop_for_plotting.txt",header = TRUE, sep="\t", quote="\"", comment.char="")
a <- match(het$POPNAME, pop$POPNAMEHET)
het2 <- data.frame(het, pop[a,])

## Test

###
### “western RHG populations exhibited much larger genetic diversities then all their respective RHG neighbors”
###

# Baka He greater than Nzime He
#Does it make sense to use the chromosomes as a vector?
wilcox.test(het2[het2$POPNAME=="Baka",]$H_E_UNBIASED_ALLSITES, het2[het2$POPNAME=="Nzime",]$H_E_UNBIASED_ALLSITES, "greater")
#The het in Baka are not significantly greater than in Nzime
#W = 302, p-value = 0.08204
#alternative hypothesis: true location shift is greater than 0

# Ba.Kola He greater than Ngumba He
wilcox.test(het2[het2$POPNAME=="BaKola",]$H_E_UNBIASED_ALLSITES, het2[het2$POPNAME=="Ngumba",]$H_E_UNBIASED_ALLSITES, "greater")
#The het in BaKola are not significantly greater than in Ngumba
#W = 282, p-value = 0.1787
#alternative hypothesis: true location shift is greater than 0

# more?

###
### “We find overall more variation in the RHG from the western part of the Congo Basin than in RHG populations from the east”
###
group1 = het2[het2$POPNAME=="Baka" | het2$POPNAME=="BaKola" | het2$POPNAME=="AkaMbati" ,]
group2 = het2[het2$POPNAME=="Nsua" | het2$POPNAME=="BaTwa" ,]
wilcox.test(group1$H_E_UNBIASED_ALLSITES, group2$H_E_UNBIASED_ALLSITES, "greater")
#significant: the het in our wRHG populations is greater than in our eRHG populations.
#W = 1898, p-value = 0.003282
#alternative hypothesis: true location shift is greater than 0

#What if we include the Biaka and the Mbuti?
group1 = het2[het2$POPNAME=="Baka" | het2$POPNAME=="BaKola" | het2$POPNAME=="AkaMbati" | het2$POPNAME=="Biaka" ,]
group2 = het2[het2$POPNAME=="Nsua" | het2$POPNAME=="BaTwa" | het2$POPNAME=="Mbuti" ,]
wilcox.test(group1$H_E_UNBIASED_ALLSITES, group2$H_E_UNBIASED_ALLSITES, "greater")
#The het in wRHG pop is greater than in the eRHG pop.
#W = 4042, p-value = 1.641e-05
#alternative hypothesis: true location shift is greater than 0

#Do we want to compare the variant counts too?

###
### “We find varying genetic variation across Northern Khoe-San populations (Xun and Juhoansi) and Southern KS populations (Nama, Karretjie People and Khomani).”
###

# nKS versus sKS, our populations only
group1 = het2[het2$POPNAME=="Xun" | het2$POPNAME=="Juhoansi" ,]
group2 = het2[het2$POPNAME=="Nama" | het2$POPNAME=="Karretjiepeople" ,]
wilcox.test(group1$H_E_UNBIASED_ALLSITES, group2$H_E_UNBIASED_ALLSITES, "two.sided")
# The two groups do not differ significantly.
#W = 1006, p-value = 0.7555
#alternative hypothesis: true location shift is not equal to 0

# nKS versus sKS, all populations
group1 = het2[het2$POPNAME=="Xun" | het2$POPNAME=="Juhoansi" | het2$POPNAME=="Juhoansi_comp" ,]
group2 = het2[het2$POPNAME=="Nama" | het2$POPNAME=="Karretjiepeople" | het2$POPNAME=="Khomani" ,]
wilcox.test(group1$H_E_UNBIASED_ALLSITES, group2$H_E_UNBIASED_ALLSITES, "two.sided")
# The two groups do not differ significantly.
#W = 2242, p-value = 0.7726
#alternative hypothesis: true location shift is not equal to 0

# within nKS (our populations)
wilcox.test(het2[het2$POPNAME=="Xun",]$H_E_UNBIASED_ALLSITES, het2[het2$POPNAME=="Juhoansi",]$H_E_UNBIASED_ALLSITES, "two.sided")
# The two populations do not differ significantly
#W = 306, p-value = 0.1372
#alternative hypothesis: true location shift is not equal to 0

# within sKS
wilcox.test(het2[het2$POPNAME=="Nama",]$H_E_UNBIASED_ALLSITES, het2[het2$POPNAME=="Karretjiepeople",]$H_E_UNBIASED_ALLSITES, "two.sided")
# W = 230, p-value = 0.7893

wilcox.test(het2[het2$POPNAME=="Nama",]$H_E_UNBIASED_ALLSITES, het2[het2$POPNAME=="Khomani",]$H_E_UNBIASED_ALLSITES, "two.sided")
# W = 307, p-value = 0.131

wilcox.test(het2[het2$POPNAME=="Khomani",]$H_E_UNBIASED_ALLSITES, het2[het2$POPNAME=="Karretjiepeople",]$H_E_UNBIASED_ALLSITES, "two.sided")
# W = 171, p-value = 0.09827


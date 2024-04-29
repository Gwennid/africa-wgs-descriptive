# 2023-07-18
# Gwenna Breton
# Goal: plot the unbiased heterozygosity by population (box plot of the values by chromosome).
#A second goal would be to combine that plot with the plot of the X-to-autosomes heterozygosity ratio against the autosomal heterozygosity.

# Scripts used to generate the data
# compute_pop_het.sh
# compute_pop_het.R

# Inputs
# I got this file from rackham:
# /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations/2024/wrapup
# It contains the expected heterozygosity for each chromosome in each population. It is used in compute_pop_het.R to make "allpop_avg_het_1-22" (average for each population).
# 20240322 TODO update with new values! These averages are combined with data from the chromosome X to calculate the ratio, and all of this can be found in "X_PARremoved_aut_ratio_perpop_withextrainfo_20200515.txt" (local file - not on rackham).

# Code
data42 <- read.table(file="/Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/africa-wgs-abc/results/heterozygosity/allchr_42pop_Het_obs_exp_bialsites.txt",header=TRUE)
info <- read.table(file="/Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/africa-wgs-abc/descriptive-analyses/45pop_info.txt", header = TRUE)

##Remove the populations for which I have no information (Because the sample size was 1)
info_42 <- info[info$POPNAMEalt != "Zulu" & info$POPNAMEalt != "Somali" & info$POPNAMEalt != "Kongo",]

boxplot(data42$H_E_UNBIASED_ALLSITES ~ data42$POPNAME, las=3) #Unbiased estimate, over all sites; range: 0.0006-0.0012
boxplot(data42$H_E_UNBIASED_VARSITES ~ data42$POPNAME) #Unbiased estimate, over variable sites; range: 0.3-0.55
boxplot(data42$H_E_ALLSITES ~ data42$POPNAME) #Uncorrected estimate, all sites; range: similar to unbiased

#Plot H_E_UNBIASED_ALLSITES
new_order_unbiased_all <- with(data42, reorder(data42$POPNAME, data42$H_E_UNBIASED_ALLSITES, median, na.rm=T))
par(mar=c(7.5, 4, 4, 2) + 0.1)
boxplot(data42$H_E_UNBIASED_ALLSITES ~ new_order_unbiased_all, ylab = "Expected unbiased heterozygosity over all sites", xlab = "", las = 3)

##Use better population names and color by pop
a <- match(levels(new_order_unbiased_all), info_42$POPNAMEalt)
info_42a <- info_42[a,]
par(mar=c(7.5, 4, 2, 2) + 0.1)
boxplot(data42$H_E_UNBIASED_ALLSITES ~ new_order_unbiased_all,
        ylab = "Expected unbiased heterozygosity over all sites", xlab = "", las = 3,
        col = info_42a$COLalt, names = info_42a$POPNAME)

##In Fan et al. they kept the order of the variant counts for the het (i.e. did not order by increasing median).

##What if I use one color per large group? Which large grouping do I want? (RHG, RHGn, KS, what else?)

#Plot H_E_UNBIASED_VARSITES
new_order_unbiased_var <- with(data42, reorder(data42$POPNAME, data42$H_E_UNBIASED_VARSITES, median, na.rm=T))
par(mar=c(7.5, 4, 4, 2) + 0.1)
boxplot(data42$H_E_UNBIASED_VARSITES ~ new_order_unbiased_var, ylab = "Expected unbiased heterozygosity over variable sites", xlab = "", las = 3)
#Highest het in CEU! Is that expected? Is there a strong effect of the population size?

##Use better population names and color by pop
b <- match(levels(new_order_unbiased_var), info_42$POPNAMEalt)
info_42b <- info_42[b,]
par(mar=c(7.5, 4, 2, 2) + 0.1)
boxplot(data42$H_E_UNBIASED_VARSITES ~ new_order_unbiased_var,
        ylab = "Expected unbiased heterozygosity over variable sites", xlab = "", las = 3,
        col = info_42b$COLalt, names = info_42b$POPNAME)

#TODO
# - replace by proper population names,
# - add color
# - combine with X-to-aut ratio plot
# - check out similar plots in e.g. Fan et al. 2023
# - is the vertical or the horizontal version better? I understand better the message in vertical, but much easier to read the labels in horizontal. -> vertical

##Things I could add to the "45pop_info.txt" file:
#population size
#a color by "large group"


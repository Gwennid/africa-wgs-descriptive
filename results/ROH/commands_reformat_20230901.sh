#Gwenna Breton
#2023-09-01
#Goal: reformat the ROH output so that we can distinguish between Juhoansi and Juhoansi (comp), and between Mandinka and Mandenka.

cd /Users/gwennabreton/Documents/Previous_work/PhD_work/P2_RHG_KS/writing/ms/ongoing/Figures/Figure_ROH
file=25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.homNEWNAMES
tr -s ' ' < $file | sed 's/^ //g' > tmp
grep Juhoansi tmp | cut -f1,2 -d" " | sort | uniq -c
#The four Juhoansi (comp) are: HGDPJUH5, SGDPJUH1, SGDPJUH3, SGDPJUH4

grep Mand tmp | cut -f1,2 -d" " | sort | uniq -ci
#The Mandinka is: 1000GMAN5

###
### Separate Juhoansi and Juhoansi comparative
###
grep -v GDPJUH tmp > tmp_no_juhoansicomp
grep GDPJUH tmp > tmp_juhoansicomp
sed 's/Juhoansi/Juhoansi_comp/g' < tmp_juhoansicomp > tmp_juhoansicomp2
cat tmp_no_juhoansicomp tmp_juhoansicomp2 > tmp2
mv tmp2 25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.homNEWNAMES.45pop
rm tmp*

###
### Separate Mandinka and Mandenka
###
cp 25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.homNEWNAMES.45pop tmp
grep -v 1000GMAN5 tmp > tmp_no_mandinka
grep 1000GMAN5 tmp > tmp_mandinka
sed 's/Mandenka/Mandinka/g' < tmp_mandinka > tmp_mandinka2
cat tmp_no_mandinka tmp_mandinka2 > tmp2
mv tmp2 25KS.48RHG.104comp.HCBP.1-22.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.bialpassSNP.HF.test1.homNEWNAMES.46pop
rm tmp* 

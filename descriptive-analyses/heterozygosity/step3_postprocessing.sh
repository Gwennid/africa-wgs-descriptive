#Run in an interactive session
cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations_2024/wrapup

#Make a summary of the biallelic sites for each chromosome and each population (autosomes)
for CHR in {1..22}; do
  for POPNAME in Baka Nzime BaKola Ngumba AkaMbati BaKiga BaTwa Nsua BaKonjo Karretjiepeople GuiandGana Juhoansi Nama Xun BantuHerero BantuKenya BantuTswana Biaka Dinka Esan Gambian Igbo Juhoansi_comp Khomani Lemande Luhya Luo Mandenka Maasai Mbuti Mende Mozabite Saharawi Yoruba DaiChinese Karitiana Papuan French CEU Coloured SothoSpeakers XhosaSpeakers Dinka_noHGDP Juhoansi_comp_noHGDP Mandenka_noHGDP Mbuti_noHGDP Yoruba_noHGDP French_noHGDP Papuan_noHGDP Karitiana_noHGDP DaiChinese_noHGDP; do
      cat chr${CHR}_${POPNAME}_bial_count_genotypes.txt |sort |uniq -c > chr${CHR}_${POPNAME}_bial_count_genotypes_summary.txt
      tail -1 chr${CHR}_${POPNAME}_bial_count_genotypes_summary.txt > header      
      sed \$d chr${CHR}_${POPNAME}_bial_count_genotypes_summary.txt > bottom
      cat header bottom > chr${CHR}_${POPNAME}_bial_count_genotypes_summary.txt
   done
done

#Make a summary of the biallelic sites for each chromosome and each population (X)
for POPNAME in Baka Nzime BaKola Ngumba AkaMbati BaKiga BaTwa Nsua BaKonjo Karretjiepeople GuiandGana Juhoansi Nama Xun BantuHerero BantuKenya BantuTswana Biaka Dinka Esan Gambian Igbo Juhoansi_comp Khomani Lemande Luhya Luo Mandenka Maasai Mbuti Mende Mozabite Saharawi Yoruba DaiChinese Karitiana Papuan French CEU Coloured SothoSpeakers XhosaSpeakers Dinka_noHGDP Juhoansi_comp_noHGDP Mandenka_noHGDP Mbuti_noHGDP Yoruba_noHGDP French_noHGDP Papuan_noHGDP Karitiana_noHGDP DaiChinese_noHGDP; do
  cat chrX_PARremoved_${POPNAME}_bial_count_genotypes.txt |sort |uniq -c > chrX_PARremoved_${POPNAME}_bial_count_genotypes_summary.txt;
  tail -1 chrX_PARremoved_${POPNAME}_bial_count_genotypes_summary.txt > header ;     
  sed \$d chrX_PARremoved_${POPNAME}_bial_count_genotypes_summary.txt > bottom;
  cat header bottom > chrX_PARremoved_${POPNAME}_bial_count_genotypes_summary.txt;
done

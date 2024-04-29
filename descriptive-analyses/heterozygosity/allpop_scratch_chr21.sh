#!/bin/bash -l
# NOTE the -l flag!
#SBATCH -J Het_scratch_21
#SBATCH -o Het_scratch_21.output
#SBATCH -e Het_scratch_21.output
# Default in slurm
#SBATCH --mail-user gwenna.breton@ebc.uu.se
#SBATCH --mail-type=FAIL,END
# Request 24 hours run time
#SBATCH -t 24:0:0
#SBATCH -A p2018003
#
#SBATCH -p core -n 2
# NOTE: You must not use more than 6GB of memory

cd $SNIC_TMP
CHR=21
prefix=25KS.48RHG.104comp.HCBP.${CHR}.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded

# Copy the VCF to scratch
cp /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/${prefix}.vcf.gz .

# Uncompress the VCF
module load bioinfo-tools tabix
bgzip -d $SNIC_TMP/${prefix}.vcf.gz

for POPNAME in BaKola Ngumba AkaMbati BaKiga BaTwa Nsua BaKonjo Karretjiepeople GuiandGana Juhoansi Nama Xun BantuHerero BantuKenya BantuTswana Biaka Dinka Esan Gambian Igbo Juhoansi_comp Khomani Lemande Luhya Luo Mandenka Maasai Mbuti Mende Mozabite Saharawi Yoruba DaiChinese Karitiana Papuan French CEU Coloured SothoSpeakers XhosaSpeakers Dinka_noHGDP Juhoansi_comp_noHGDP Mandenka_noHGDP Mbuti_noHGDP Yoruba_noHGDP French_noHGDP Papuan_noHGDP Karitiana_noHGDP; do
# Count the different configurations
python /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/bash_outputs/2024/Het_calculations_${POPNAME}_${CHR}.py ;
# Copy the outputs back
cp $SNIC_TMP/*${POPNAME}*txt /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations_2024/ ;
done

cp $SNIC_TMP/chr${CHR}_novar_bypop_weird.txt /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations_2024/


#!/bin/bash -l
# NOTE the -l flag!
#SBATCH -J Het_scratch_test_2
#SBATCH -o Het_scratch_test_2.output
#SBATCH -e Het_scratch_test_2.output
# Default in slurm
#SBATCH --mail-user gwenna.breton@ebc.uu.se
#SBATCH --mail-type=FAIL,END
# Request 6 hours run time
#SBATCH -t 12:0:0
#SBATCH -A p2018003
#
#SBATCH -p core -n 2
# NOTE: You must not use more than 6GB of memory

cd $SNIC_TMP
CHR=2
prefix=25KS.48RHG.104comp.HCBP.${CHR}.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded

# Copy the VCF to scratch
cp /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/${prefix}.vcf.gz .

# Uncompress the VCF
module load bioinfo-tools tabix
bgzip -d $SNIC_TMP/${prefix}.vcf.gz

for POPNAME in Baka Nzime BaKola; do
# Count the different configurations
python /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/bash_outputs/2024/Het_calculations_${POPNAME}_${CHR}.py ;
# Copy the outputs back
cp $SNIC_TMP/*${POPNAME}*txt /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations_2024/ ;
done

cp $SNIC_TMP/chr${CHR}_novar_bypop_weird.txt /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations_2024/


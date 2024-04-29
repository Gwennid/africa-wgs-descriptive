#Gwenna Breton
#2024-02-07
#Goal: prepare script to count variant and non-variant positions in different configurations, for a given chromosome and a given set of individuals (representing a population).

# Prepare the script
cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/bash_outputs/2024
CHR=22
POPNAME=Nsua ;
sed "s/chromosome/${CHR}/g" < Het_calculations_bypop_bychr.py | sed "s/popname/${POPNAME}/g" | sed "s/indname/['PNP070','PNP071','PNP072','PNP073','PNP074']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;

# Submit the script
(echo '#!/bin/bash -l'
echo "
cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations_2024
python /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/bash_outputs/2024/Het_calculations_${POPNAME}_${CHR}.py ;
exit 0") | sbatch -p core -n 6 -t 12:0:0 -A p2018003 -J count_het_${CHR}_${POPNAME} -o count_het_${CHR}_${POPNAME}.output -e count_het_${CHR}_${POPNAME}.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL

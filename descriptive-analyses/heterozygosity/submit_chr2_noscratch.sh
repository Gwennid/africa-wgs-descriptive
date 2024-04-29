#Gwenna Breton
#2024-02-18
#Goal: submit script to count variant and non-variant positions in different configurations, for a given chromosome and a given set of individuals (representing a population). Not using scratch.

CHR=2
POPNAME=Nzime
cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/bash_outputs/2024

# Submit the script
(echo '#!/bin/bash -l'
echo "
cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/HC_BPresolution/3maskrecal.realn/allsites/3_geno01_hwefiltering/het_calculations_2024/local
python /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/bash_outputs/2024/Het_calculations_${POPNAME}_${CHR}.py ;
exit 0") | sbatch -p core -n 2 -t 12:0:0 -A p2018003 -J count_het_${CHR}_${POPNAME}_local -o count_het_${CHR}_${POPNAME}_local.output -e count_het_${CHR}_${POPNAME}_local.output --mail-user gwenna.breton@ebc.uu.se --mail-type=FAIL

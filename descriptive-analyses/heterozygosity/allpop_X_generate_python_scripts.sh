#Gwenna Breton
#2024-03-15
#Prepare count variant configurations scripts for chromosome X in all population sets.

cd /crex/proj/snic2020-2-10/uppstore2017183/b2012165_nobackup/private/Seq_project_cont/bash_outputs/2024
CHR="X_PARremoved"
#
POPNAME=Baka ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['PNP000','PNP001','PNP002','PNP003','PNP004','PNP005','PNP006']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=Nzime ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['PNP010','PNP011','PNP012','PNP013','PNP014']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=BaKola ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['PNP020','PNP021','PNP022','PNP023','PNP024']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=Ngumba ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['PNP030','PNP031','PNP032','PNP033','PNP034']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=AkaMbati ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['PNP040','PNP041','PNP042','PNP043','PNP044']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=BaKiga ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['PNP050','PNP051','PNP052','PNP053','PNP054']/g" > Het_calculations_${POPNAME}_${CHR}.py ; 
#
POPNAME=BaTwa ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['PNP060','PNP062','PNP063','PNP064','PNP065','PNP066']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Nsua ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['PNP070','PNP071','PNP072','PNP073','PNP074']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=BaKonjo ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['PNP080','PNP081','PNP082','PNP083','PNP084']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Karretjiepeople ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['KSP062','KSP063','KSP065','KSP067','KSP069']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=GuiandGana ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['KSP092','KSP096','KSP224','KSP225','KSP228']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=Juhoansi ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['KSP103','KSP105','KSP106','KSP111','KSP116']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Nama ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['KSP124','KSP134','KSP137','KSP139','KSP140']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
# 
POPNAME=Xun ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['KSP146','KSP150','KSP152','KSP154','KSP155']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=BantuHerero ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005443-DNA_E02','SGDP_LP6005441-DNA_F01']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=BantuKenya ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005443-DNA_A01','SGDP_LP6005441-DNA_B02']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=BantuTswana ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005443-DNA_G02','SGDP_LP6005443-DNA_F02']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Biaka ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005441-DNA_G02','SGDP_LP6005441-DNA_H02']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Esan ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005442-DNA_A10','SGDP_LP6005442-DNA_B10','HG02922']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Gambian ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005442-DNA_G10','SGDP_LP6005442-DNA_H10']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Igbo ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_EGAR00001482721_LP6005519-DNA_A12','SGDP_EGAR00001482720_LP6005519-DNA_B12']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Juhoansi_comp ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005443-DNA_G08','SGDP_LP6005441-DNA_A11','SGDP_SS6004473','HGDP_HGDP01029']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Khomani ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005677-DNA_D03','SGDP_LP6005592-DNA_C05']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Lemande ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_EGAR00001482719_LP6005677-DNA_C04','SGDP_EGAR00001482718_LP6005677-DNA_D04']/g" > Het_calculations_${POPNAME}_${CHR}.py ; 
#
POPNAME=Luhya ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005442-DNA_F11','SGDP_LP6005442-DNA_E11','NA19017']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Luo ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005677-DNA_G01','SGDP_LP6005442-DNA_F09']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Mandenka ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005441-DNA_E07','SGDP_LP6005441-DNA_F07','SGDP_SS6004470','HGDP_HGDP01284']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Maasai ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005443-DNA_F06','SGDP_LP6005443-DNA_E06']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Mbuti ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005592-DNA_C03','SGDP_LP6005441-DNA_B08','SGDP_LP6005441-DNA_A08','SGDP_SS6004471','HGDP_HGDP00456']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Mende ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005442-DNA_G11','SGDP_LP6005442-DNA_H11','HG03052']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Mozabite ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005441-DNA_G08','SGDP_LP6005441-DNA_H08']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Saharawi ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005619-DNA_B01','SGDP_LP6005619-DNA_C01']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Yoruba ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005442-DNA_B02','SGDP_LP6005442-DNA_A02','SGDP_SS6004475','HGDP_HGDP00927']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=DaiChinese ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005592-DNA_D03','SGDP_LP6005443-DNA_B01','SGDP_LP6005441-DNA_D04','SGDP_SS6004467','HGDP_HGDP01307','HG00759']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=Karitiana ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005441-DNA_G06','SGDP_LP6005441-DNA_H06','SGDP_SS6004476','Rasmussen_KAR4','HGDP_HGDP00998']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=Papuan ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005441-DNA_B10','SGDP_LP6005443-DNA_C08','SGDP_LP6005443-DNA_B08','SGDP_LP6005443-DNA_G07','SGDP_LP6005443-DNA_D08','HGDP_HGDP00542']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=French ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005441-DNA_A05','SGDP_LP6005441-DNA_B05','SGDP_SS6004468','HGDP_HGDP00521']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=CEU ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['NA12891','NA12892']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=Coloured ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SAHGP_EGAZ00001314195_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_A01_Assembly_LP6005857-DNA_A01','SAHGP_EGAZ00001314196_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_B01_Assembly_LP6005857-DNA_B01','SAHGP_EGAZ00001314197_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_C01_Assembly_LP6005857-DNA_C01','SAHGP_EGAZ00001314198_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_D01_Assembly_LP6005857-DNA_D01','SAHGP_EGAZ00001314199_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_E01_Assembly_LP6005857-DNA_E01','SAHGP_EGAZ00001314200_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_F01_Assembly_LP6005857-DNA_F01','SAHGP_EGAZ00001314201_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_G01_Assembly_LP6005857-DNA_G01','SAHGP_EGAZ00001314202_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_H01_Assembly_LP6005857-DNA_H01']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=SothoSpeakers ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SAHGP_EGAZ00001314204_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_B02_Assembly_LP6005857-DNA_B02','SAHGP_EGAZ00001314205_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_C02_Assembly_LP6005857-DNA_C02','SAHGP_EGAZ00001314206_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_D02_Assembly_LP6005857-DNA_D02','SAHGP_EGAZ00001314207_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_E02_Assembly_LP6005857-DNA_E02','SAHGP_EGAZ00001314208_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_F02_Assembly_LP6005857-DNA_F02.bam','SAHGP_EGAZ00001314209_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_G02_Assembly_LP6005857-DNA_G02','SAHGP_EGAZ00001314210_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_H02_Assembly_LP6005857-DNA_H02']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=XhosaSpeakers ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SAHGP_EGAZ00001314211_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_A03_Assembly_LP6005857-DNA_A03','SAHGP_EGAZ00001314212_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_B03_Assembly_LP6005857-DNA_B03','SAHGP_EGAZ00001314213_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_C03_Assembly_LP6005857-DNA_C03','SAHGP_EGAZ00001314214_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_D03_Assembly_LP6005857-DNA_D03','SAHGP_EGAZ00001314215_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_E03_Assembly_LP6005857-DNA_E03','SAHGP_EGAZ00001314216_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_F03_Assembly_LP6005857-DNA_F03','SAHGP_EGAZ00001314217_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_G03_Assembly_LP6005857-DNA_G03','SAHGP_EGAZ00001314218_sequence_files_ega_Illumina_FTS_20140424_LP6005857-DNA_H03_Assembly_LP6005857-DNA_H03']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=Dinka ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005443-DNA_H08','SGDP_LP6005443-DNA_B09','SGDP_SS6004480','HGDP_DNK02']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
# Prepare code for "noHGDP" sets
POPNAME=Dinka_noHGDP ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005443-DNA_H08','SGDP_LP6005443-DNA_B09','SGDP_SS6004480']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Juhoansi_comp_noHGDP ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005443-DNA_G08','SGDP_LP6005441-DNA_A11','SGDP_SS6004473']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Mandenka_noHGDP ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005441-DNA_E07','SGDP_LP6005441-DNA_F07','SGDP_SS6004470']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Mbuti_noHGDP ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005592-DNA_C03','SGDP_LP6005441-DNA_B08','SGDP_LP6005441-DNA_A08','SGDP_SS6004471']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=Yoruba_noHGDP ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005442-DNA_B02','SGDP_LP6005442-DNA_A02','SGDP_SS6004475']/g" > Het_calculations_${POPNAME}_${CHR}.py  ;
#
POPNAME=French_noHGDP ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005441-DNA_A05','SGDP_LP6005441-DNA_B05','SGDP_SS6004468']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=Papuan_noHGDP ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005441-DNA_B10','SGDP_LP6005443-DNA_C08','SGDP_LP6005443-DNA_B08','SGDP_LP6005443-DNA_G07','SGDP_LP6005443-DNA_D08']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=Karitiana_noHGDP ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005441-DNA_G06','SGDP_LP6005441-DNA_H06','SGDP_SS6004476','Rasmussen_KAR4']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#
POPNAME=DaiChinese_noHGDP ;
sed "s/popname/${POPNAME}/g" Het_calculations_bypop_X_PARremoved.py | sed "s/indname/['SGDP_LP6005592-DNA_D03','SGDP_LP6005443-DNA_B01','SGDP_LP6005441-DNA_D04','SGDP_SS6004467','HG00759']/g" > Het_calculations_${POPNAME}_${CHR}.py ;
#

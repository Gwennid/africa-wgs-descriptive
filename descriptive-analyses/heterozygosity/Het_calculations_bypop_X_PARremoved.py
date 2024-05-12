### Gwenna Breton
### 2024-03-15
### Goal: count number of each type of genotype in a population. The output will be used to compute heterozygosity.
# Based on the file with the same name from 2019.

# Caution! This takes a VCF as input not a VCF.GZ

## INPUT FILE
vcf = open("ALLDATA_X_JG.20190808.177ind.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2.H.vcf") #adapt name if needed!

## OUTPUT FILES
#novar_bypop_weird = open("chrX_novar_popname_weird.txt", "w")
pop_count = open("chrX_PARremoved_popname_count.txt", "w")
bial_pop = open("chrX_PARremoved_popname_bial_count_genotypes.txt", "w")
bial_pop.write("DIPLOID_HOM_REF\tHAPLOID_REF\tDIPLOID_HOM_ALT\tHAPLOID_ALT\tHET\n")

## INITIALIZE VARIABLES
NOVAR_MISSING = 0
NOVAR_HOM_REF = 0
BIAL_MISSING = 0
BIAL_NOVAR_POP_HOM_REF = 0
BIAL_NOVAR_POP_HOM_ALT = 0
BIAL_POP = 0
TRIAL_MISSING = 0
TRIAL_NOVAR_POP_HOM_REF = 0
TRIAL_NOVAR_POP_HOM_ALT1 = 0
TRIAL_NOVAR_POP_HOM_ALT2 = 0
TRIAL_POP = 0
PAR = 0

## LIST OF ID FOR THE POPULATION
ind = indname
IND = ['a'] * len(ind)

## READ VCF LINE BY LINE ; FOCUS ON GENOTYPES IN A POPULATION
for line in vcf:
	line = line.strip()
	if line[0:2] == "##":
		print("Header line, skipping")
	elif line[0:6] == "#CHROM": #that should be the line with the sample names
		header=list(line.split("\t"))
		for x in range(len(ind)):
			IND[x] = header.index(ind[x])
	elif line[0:3] == "chr": #now we can start looking at the sites!
		Line=list(line.split("\t"))
		# We do not want to count the PAR sites. So first step is to check we are outside the PAR regions.
		pos=int(Line[1])
		if ((pos > 10000 and pos < 2781480) or (pos > 155701382 and pos < 156030896)):
			PAR += 1
		else:
			filt=Line[6]
			# Case of expected non variant sites. The other sites are not considered.
			if filt == ".":
				if len(Line[3]) == 1 and Line[4] == ".":
					GENOTYPE = ['a'] * len(ind)
					for x in range(len(ind)):
						ind_info=Line[IND[x]]
						GENOTYPE[x] = list(ind_info.split(":"))[0]
					if './.' in GENOTYPE or '.' in GENOTYPE: NOVAR_MISSING += 1
					elif set(GENOTYPE) == {'0/0'} or set(GENOTYPE) == {'0'} or set(GENOTYPE) == {'0/0','0'}: NOVAR_HOM_REF += 1 #TODO check that this works!	
					else: novar_bypop_weird.write(line)
			elif filt == "PASS":
				# Case of biallelic SNP
				if len(Line[3]) == 1 and len(Line[4]) == 1:
					GENOTYPE = ['a'] * len(ind)
					for x in range(len(ind)):
						ind_info=Line[IND[x]]
						GENOTYPE[x] = list(ind_info.split(":"))[0]
					if  './.' in GENOTYPE or '.' in GENOTYPE: BIAL_MISSING += 1
					elif set(GENOTYPE) == {'0/0'} or set(GENOTYPE) == {'0'} or set(GENOTYPE) == {'0/0','0'}: BIAL_NOVAR_POP_HOM_REF += 1
					elif set(GENOTYPE) == {'1/1'} or set(GENOTYPE) == {'1'} or set(GENOTYPE) == {'1/1','1'}: BIAL_NOVAR_POP_HOM_ALT += 1
					else:
						BIAL_POP += 1
						diploid_hom_ref = GENOTYPE.count('0/0') 
						haploid_ref = GENOTYPE.count('0')					
						diploid_hom_alt = GENOTYPE.count('1/1')
						haploid_alt = GENOTYPE.count('1')	
						het = GENOTYPE.count('0/1')				
						bial_pop.write("%i\t%i\t%i\t%i\t%i\n" % (diploid_hom_ref, haploid_ref, diploid_hom_alt, haploid_alt, het))
				else:
					list_ref=list(Line[3].split(","))
					list_alt=list(Line[4].split(","))
					# Case of multiallelic SNP (I consider only triallelic sites further)
					if len(list_ref) == 1 and len(Line[3]) == 1:
						# Case of triallelic SNP
						if len(list_alt) == 2 and len(Line[4]) == 3:
							GENOTYPE = ['a'] * len(ind)
							for x in range(len(ind)):
								ind_info=Line[IND[x]]
								GENOTYPE[x] = list(ind_info.split(":"))[0]
							if  './.' in GENOTYPE or '.' in GENOTYPE: TRIAL_MISSING += 1
							elif set(GENOTYPE) == {'0/0'} or set(GENOTYPE) == {'0'} or set(GENOTYPE) == {'0/0','0'}: TRIAL_NOVAR_POP_HOM_REF += 1
							elif set(GENOTYPE) == {'1/1'} or set(GENOTYPE) == {'1'} or set(GENOTYPE) == {'1/1','1'}: TRIAL_NOVAR_POP_HOM_ALT1 += 1
							elif set(GENOTYPE) == {'2/2'} or set(GENOTYPE) == {'2'} or set(GENOTYPE) == {'2/2','2'}: TRIAL_NOVAR_POP_HOM_ALT2 += 1
							else: TRIAL_POP += 1
								

## Now write summary files
pop_count.write("%s\t%i\n" % ("NOVAR_MISSING", NOVAR_MISSING))
pop_count.write("%s\t%i\n" % ("NOVAR_HOM_REF", NOVAR_HOM_REF))
pop_count.write("%s\t%i\n" % ("BIAL_MISSING", BIAL_MISSING))
pop_count.write("%s\t%i\n" % ("BIAL_NOVAR_POP_HOM_REF", BIAL_NOVAR_POP_HOM_REF))
pop_count.write("%s\t%i\n" % ("BIAL_NOVAR_POP_HOM_ALT", BIAL_NOVAR_POP_HOM_ALT))
pop_count.write("%s\t%i\n" % ("BIAL_POP", BIAL_POP))
pop_count.write("%s\t%i\n" % ("TRIAL_MISSING", TRIAL_MISSING))
pop_count.write("%s\t%i\n" % ("TRIAL_NOVAR_POP_HOM_REF", TRIAL_NOVAR_POP_HOM_REF))
pop_count.write("%s\t%i\n" % ("TRIAL_NOVAR_POP_HOM_ALT1", TRIAL_NOVAR_POP_HOM_ALT2))
pop_count.write("%s\t%i\n" % ("TRIAL_NOVAR_POP_HOM_ALT2", TRIAL_NOVAR_POP_HOM_ALT2))
pop_count.write("%s\t%i\n" % ("TRIAL_POP", TRIAL_POP))
pop_count.write("%s\t%i\n" % ("SITE_IN_PAR", PAR))
pop_count.close()

## CLOSE FILES
bial_pop.close()


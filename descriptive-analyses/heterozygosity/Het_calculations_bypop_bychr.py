### Gwenna Breton
### 2024-02-07
### Goal: count number of each type of genotype in a population. The output will be used to compute heterozygosity.
# Based on the file with the same name from 2019.

# Caution! This takes a VCF as input not a VCF.GZ

## INPUT FILE
vcf = open("25KS.48RHG.104comp.HCBP.chromosome.recalSNP99.9.recalINDEL99.0.FAIL1FAIL2FAIL3.reheaded.vcf")

## OUTPUT FILES
novar_bypop_weird = open("chrchromosome_novar_bypop_weird.txt", "w")
pop_count = open("chrchromosome_popname_count.txt", "w")
bial_pop = open("chrchromosome_popname_bial_count_genotypes.txt", "w")
trial_pop = open("chrchromosome_popname_trial_count_genotypes.txt", "w")
bial_pop.write("HOM_REF\tHOM_ALT\tHET\n")
trial_pop.write("HOM_REF\tHOM_ALT1\tHOM_ALT2\tHET_REF_ALT1\tHET_REF_ALT2\tHET_ALT1_ALT2\n")

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
		filt=Line[6]
		# Case of expected non variant sites. The other sites are not considered.
		if filt == ".":
			if len(Line[3]) == 1 and Line[4] == ".":
				GENOTYPE = ['a'] * len(ind)
				for x in range(len(ind)):
					ind_info=Line[IND[x]]
					GENOTYPE[x] = list(ind_info.split(":"))[0]
				if './.' in GENOTYPE: NOVAR_MISSING += 1
				elif set(GENOTYPE) == {'0/0'}: NOVAR_HOM_REF += 1
				else: novar_bypop_weird.write(line)
		elif filt == "PASS":
			# Case of biallelic SNP
			if len(Line[3]) == 1 and len(Line[4]) == 1:
				GENOTYPE = ['a'] * len(ind)
				for x in range(len(ind)):
					ind_info=Line[IND[x]]
					GENOTYPE[x] = list(ind_info.split(":"))[0]
				if  './.' in GENOTYPE: BIAL_MISSING += 1
				elif set(GENOTYPE) == {'0/0'}: BIAL_NOVAR_POP_HOM_REF += 1
				elif set(GENOTYPE) == {'1/1'}: BIAL_NOVAR_POP_HOM_ALT += 1
				else:
					BIAL_POP += 1
					hom_ref = GENOTYPE.count('0/0')
					hom_alt = GENOTYPE.count('1/1')
					het = GENOTYPE.count('0/1')
					bial_pop.write("%i\t%i\t%i\n" % (hom_ref, hom_alt, het))
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
						if  './.' in GENOTYPE: TRIAL_MISSING += 1
						elif set(GENOTYPE) == {'0/0'}: TRIAL_NOVAR_POP_HOM_REF += 1
						elif set(GENOTYPE) == {'1/1'}: TRIAL_NOVAR_POP_HOM_ALT1 += 1
						elif set(GENOTYPE) == {'2/2'}: TRIAL_NOVAR_POP_HOM_ALT2 += 1
						else:
							TRIAL_POP += 1
							hom_ref = GENOTYPE.count('0/0')
							hom_alt1 = GENOTYPE.count('1/1')
							hom_alt2 = GENOTYPE.count('2/2')
							het_ref_alt1 = GENOTYPE.count('0/1')
							het_ref_alt2 = GENOTYPE.count('0/2')
							het_alt1_alt2 = GENOTYPE.count('1/2')
							trial_pop.write("%i\t%i\t%i\t%i\t%i\t%i\n" % (hom_ref, hom_alt1, hom_alt2, het_ref_alt1, het_ref_alt2, het_alt1_alt2))

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
pop_count.close()

## CLOSE FILES
trial_pop.close()
bial_pop.close()



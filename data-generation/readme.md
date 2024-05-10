This folder contains information regarding how the data was generated.

- [ ] Insert the (updated) flowchart

# Mapping

## Step0.1

We mapped reads to GRCh38 using bwakit/0.7.12 `bwa-mem` with the alt-aware procedure. The resulting BAM file was sorted and indexed. The mapping was done by lane for the data generated in this study, and by what we assumed to be lanes for the comparative dataset. The code changes depending on the input:

- FASTQ: data generated in this study, SGDP (except "SGDP letter") and KGP: [step0.1.a_mapping.sh](step0.1.a_mapping.sh)
- mapped BAM: SGDP letter (IGB1, IGB2, KON2, LEM1, LEM2), HGDP, SAHGP: [step0.1.b_mapping.sh](step0.1.b_mapping.sh)
- mapped BAM from which reads of interest need to be extracted: Schlebusch et al. 2020 (the same 25 Khoe-San individuals as included in this study):  [step0.1.c_mapping.sh](step0.1.c_mapping.sh)

## Step0.2

In order to reduce the size of the BAM files we split the indexed BAM bwa into one BAM containing mapped reads and one containing unmapped reads (with samtools/1.1). Only the files with mapped reads were processed further. This is done in: [step_0.2_split-mapped-unmapped.sh](step_0.2_split-mapped-unmapped.sh)


#!/bin/bash -l 
#genomesequence=Gmax_275_v2.0.fa
#annotation_file=Gmax_275_Wm82.a2.v1.gene_exons.gff3
#settings_jobs_to_server=qsub -l mem=40gb,nodes=1:ppn=1,walltime=8:00:00 [Script*.sh]
#get the genomic sequence (.fa) and gene annotation file (.gff3) of your species and put it in the $Workingdir
#get the raw FASTQ-file(s) from the EBI or NCBI server using wget 
#for Single-End use:
wget -P $Workingdir/ ftp.sra.ebi.ac.uk/../FASTQfile.fastq.gz
#for for Paired-End use:
wget -P $Workingdir/ ftp.sra.ebi.ac.uk/../FASTQfile_1.fastq.gz
wget -P $Workingdir/ ftp.sra.ebi.ac.uk/../FASTQfile_2.fastq.gz
#unpack the archived (.gz) files
gunzip -d $Workingdir/FASTQfile*.fastq.gz
#trim FASTQ file by quality and length using sickle
#for Single-End use, length (option -l) and quality (option -q) can be adjusted:
sickle se -f  $Workingdir/FASTQfile.fastq -t sanger -o  $Workingdir/trimmed_FASTQfile.fastq -q 30 -l 35
#for for Paired-End use, length (option -l) and quality (option -q) can be adjusted:
sickle pe -f  $Workingdir/FASTQfile_1.fastq -r $Workingdir/FASTQfile_2.fastq -t sanger -o $Workingdir/trimmed_FASTQfile_1.fastq -p $Workingdir/trimmed_FASTQfile_2.fastq -s $Workingdir/trimmed_FASTQfiles_S.fastq -q 30 -l 35
#make a mapable genome sequence using STAR, you only need to do this once for each genome
STAR --runMode genomeGenerate --genomeDir  $Workingdir/genomeDir  --genomeFastaFiles $Workingdir/Genomesequence.fa --sjdbGTFfile $Workingdir/Gene_annotationfile.gff3 --sjdbGTFtagExonParentTranscript Parent --sjdbOverhang 100 --runThreadN 8
#map your reads in BAM-format on the mapable genomic sequence using STAR
#for Single-End use:
STAR --genomeDir  $Workingdir/genomeDir --readFilesIn $Workingdir/trimmed_FASTQfile.fastq --runThreadN 8 --outSAMtype BAM SortedByCoordinate --outFileNamePrefix $Workingdir/FASTQfile
#for Paired-End use:
STAR --genomeDir  $Workingdir/genomeDir --readFilesIn $Workdir/trimmed_FASTQfile_1.fastq $Workdir/trimmed_FASTQfile_2.fastq --runThreadN 8 --outSAMtype BAM SortedByCoordinate --outFileNamePrefix $Workingdir/FASTQfile
#count per annotated gene the number of mapped reads using htseq-count
htseq-count -s no -r pos -t gene -i ID -f bam $Workingdir/FASTQfileAligned.sortedByCoord.out.bam $Workingdir/Gene_annotationfile.gff3 > $Workingdir/FASTQfile-output_basename_gene.counts
#optional remove of the inputfiles using rm 
rm $Workingdir/FASTQfile.fastq $Workingdir/trimmed_FASTQfile.fastq $Workingdir/FASTQfileAligned.sortedByCoord.out.bam
#find the counts for your genes of interest in the given experiment using the grep function 
grep -E 'gene1|gene2|..' FASTQfile-output_basename_gene.counts
#run_debug_run_again_make_it_work#####

###################################################
###################################################

#https://www.we.vub.ac.be/nl/plant-genetics########
#programming: Raphael Kiekens, Ramon De Koning
###################################################
#
#Art by Joan G. Stark
#                                    _._
#                                  .'   '.
#                                 /       \  ___
#                _..       _.--. |     /  |.'   `'.
#       ;-._   .'   `\   .'     `\   \|   /        \
#     .'    `\/       ; /     _   \.=..=./  _.'    /
#     |       `\.---._| '.   .-'-.}`.<>.`{-'-.    /
#  .--;   . ( .'      '.  \ .---.{ <>()<> }.--..-'
# / _  \_  './ _.       `-./     _},'<>`.{_    `\
#( = \  )`""'\;--.         /  .-'/ )=..=;`\`-    \
#{= (|  )     /`.         /       /  /| \         )
#( =_/  )__..-\         .'-..___.'    :  '.___..-'
# \    }/    / ;.____.-;/\      |      `   |
#  '--' |  .'   |       \ \     /'.      _.'
#       \  '    /       |\.\   ;  /`--.-'
#        )    .'`-.    /  \ \  |`|
#       /__.-'     \_.'jgs \ \ |-|
#
#
###################################################
###################################################
###################################################

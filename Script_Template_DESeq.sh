####DIFFERENTIAL_EXPRESSION_ANALYSIS_USING_DESeq.R
##2-R-script using the DESeq2 package in R for differential expression analysis. 
##An example is given for three control count-files (FASTQfileC1..3-output_basename_gene_counts) and three treatment count-files (FASTQfileT1..3_basename_gene_counts)
#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("DESeq2")
outputPrefix <- "FASTQfile_NAME_EXP"
sampleFiles<- c("FASTQfileC1-output_basename_gene.counts","FASTQfileC2-output_basename_gene.counts","FASTQfileC3-output_basename_gene.counts","FASTQfileT1-output_basename_gene.counts","FASTQfileT2-output_basename_gene.counts","FASTQfileT3-output_basename_gene.counts")
sampleNames <- c("CONTROL1","CONTROL2","CONTROL3","TREATMENT1","TREATMENT2","TREATMENT3")
sampleCondition <- c("control","control","control","treatment","treatment","treatment")
sampleTable <- data.frame(sampleName = sampleNames, fileName = sampleFiles, condition = sampleCondition)
treatments = c("control","treatment")
library("DESeq2")
ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,directory = directory,design = ~ condition)
colData(ddsHTSeq)$condition <- factor(colData(ddsHTSeq)$condition,levels = treatments)
dds <- DESeq(ddsHTSeq)
res <- results(dds)
resdata <- merge(as.data.frame(res), as.data.frame(counts(dds,normalized =TRUE)), by = 'row.names', sort = FALSE)
names(resdata)[1] <- 'gene'
write.csv(resdata, file = paste0(outputPrefix, "-results-with-normalized.csv"))
##3-use the ‘grep’ function in your linux/unix-shell or the ‘VLOOKUP’ function in Excel for extracting the Deseq results for your genelist of interest
#shell script:
grep -E 'gene|gene1|gene2|..|..' FASTQfile_NAME_EXP-results-with-normalized.csv > SELECTION_FASTQfile_NAME_EXP-results-with-normalized.csv
#or in Excel:
=VLOOKUP(lookup value, range containing the lookup value, the column number in the range containing the return value, Exact match (FALSE)).
##You should have a final table with following header and corresponding data: 'gene;baseMean;log2FoldChange;lfcSE;stat;pvalue;padj;CONTROLl;CONTROL2;CONTROL3;TREATMENT1;TREATMENT2;TREATMENT3'##


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

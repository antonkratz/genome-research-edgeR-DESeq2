# author:       Anton Kratz
# created:      Tue Dec  1 14:12:44 JST 2015
# last change:  Tue Apr  5 14:24:20 JST 2016

# R version 3.2.2 (2015-08-14) -- "Fire Safety"
# Platform: x86_64-pc-linux-gnu (64-bit)

# This assumes the presence of a directory 'newresults' to store output files in,
# and presence of input files 'expr_table.csv' and 'expr_table.desc.csv'.

library("DESeq2")
library("ggplot2")
library("corrplot")

setwd("~/genome-research-edgeR")

# Define the main test function
de_check <- function (this_dds, this_contrast, outfile) {
	res <- results(this_dds, contrast=this_contrast)
	write.table(as.data.frame(res),file=paste(outfile, ".txt", sep = ""), quote=FALSE, sep="\t")
	print(sum(res$padj < 0.1, na.rm=TRUE))
	print(sum(res$pvalue < 0.05, na.rm=TRUE))
	DESeq2::plotMA(res)
}

mycountdata <- read.delim("data/expr_table.bmemb_vs_bcyto.csv", header = TRUE, sep = "\t")
mycoldata <- read.delim("data/expr_table.desc.bmemb_vs_bcyto.csv", header = TRUE, sep = "\t")

# the next step takes some minutes...
dds <- DESeqDataSetFromMatrix(countData = mycountdata, colData = mycoldata, design = ~ replicate + compartment)
dds <- DESeq(dds)

de_check(dds, c("compartment","memb","cyto"), "data/DESeq2.bmemb_vs_bcyto")


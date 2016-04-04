# author:               Anton Kratz
# created:              Fri Jan 29 11:40:42 JST 2016
# last change:          Mon Apr  4 12:47:50 JST 2016
# modified by Charles:  Mon Feb  1

# ```{r load_data}
library(edgeR)
library("magrittr")

setwd("~/genome-research-edgeR")

mycountdata <- read.delim("data/expr_table.bound_vs_unbound.csv", header = TRUE, sep = "\t")
mycoldata <- read.delim("data/expr_table.desc.bound_vs_unbound.csv", header = TRUE, sep = "\t")

cds <- DGEList(mycountdata, group = mycoldata$pulldown) %>% calcNormFactors

plotMDS(cds , main = "MDS Plot for Count Data", labels = colnames(cds$counts))

plotSmear(cds)

gen_diffexp <- function(design) {
  glm <- estimateDisp(cds,design) %>%
           glmFit(design) %>%
           glmLRT
  decideTestsDGE(glm) %>% summary %>% print
  invisible(glm)
}

plot_results <- function(glm, main) {
  plotSmear( glm
           , de.tags=rownames(glm)[decideTestsDGE(glm) != 0]
           , cex=0.5
           , main = main)
  invisible(glm)
}



design <- with(mycoldata, model.matrix(~replicate+pulldown))
glm <- gen_diffexp(design)
topTags(glm)
plot_results(glm, "~replicate+pulldown")

tab <- topTags(glm, n=Inf)
write.table(tab, file="data/edgeR.bound_vs_unbound.txt", sep='\t', quote=F)

# ```

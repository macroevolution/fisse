
# Example script illustrating use of FISSE test


library(ape)
library(phangorn)
library(diversitree)

source("traitDependent_functions.R")

tree          <- read.tree("example_tree.tre")
xx            <- read.csv("example_trait.csv", header=F)
traits        <- xx[,2]
names(traits) <- xx[,1]
 

traits <- traits[tree$tip.label]

#---- Plot tree w traits before analysis

colvec <- rep("white", length(traits))
colvec[traits == 1] <- "black"

quartz.options(height=12, width=12)
plot.phylo(tree, type = "fan", show.tip.label=F)
tiplabels(pch=21, bg=colvec, cex=0.8)

#------- Arguments to FISSE.binary function	
#
#    phy               = class phylo phylogenetic tree
#    states            = vector of state data (must have names attribute)
#    reps              = Number of simulations to perform when generating null distribution
#    tol               = tolerance value to accept simulation as valid
#                           default value of 0.1 means that null simulations will be accepted 
#                           if parsimony-reconstructed changes are +/- 10% of the observed value
#    qratetype         = How to estimate rates for the mk1 simulations of the null distribution. 
#                            default value of mk1 fits a symmetric 1-rate Mk model to the data
#                            option "parsimony" simply divides the number of changes by the summed edge lengths
#                     
 
 
res <- FISSE.binary(tree, traits)


# components of returned object:
#
#    lambda0           = inverse splits rate estimate for state 0
#    lambda1           = inverse splits rate estimate for state 1
#    pval              = proportion of simulations where observed test statistic (lambda1 - lambda0)
#                           greater than the simulated value.
#   null_mean_diff     =   average (lambda1 - lambda0) for null distribution           
#   null_sd            =  std deviation of the null distribution
#   nchanges_parsimony = number of parsimony-reconstructed changes in trait values
#   qpars              = transition rate under symmetric (Mk1) model of trait evolution
#	                         (used to simulated null distribution)

# two-tailed pvalue is obtained as
pval_2tailed   <- min(res$pval, 1-res$pval)*2

# this example should give significant evidence for SDD 
#    (this is correct: for this dataset, 
#        state 0 has lambda = 0.05 and state 1 has lambda = 0.1, with mu0 = mu1 = 0.01)
#
#


# Here is an example with incomplete trait data:


tree          <- read.tree("example_tree.tre")
xx            <- read.csv("example_trait.csv", header=F)
traits        <- xx[,2]
names(traits) <- xx[,1]
 
# Drop some random trait data

# Drop size of trait dataset to 80% of current length:
dropcount <- round(0.80 * length(traits))

traits <- traits[sample(1:length(traits), size = dropcount )]

res <- FISSE.binary(tree, traits, incomplete = T)











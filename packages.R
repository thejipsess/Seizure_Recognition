#=========================================#
##       Install missing packages        ##
#=========================================#

# Update all packages
#update.packages()

# BiocManager
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

# Principal Component Analysis
if (!requireNamespace("pcaMethods", quietly = TRUE))
  BiocManager::install("pcaMethods")

if (!requireNamespace("knitr", quietly = TRUE))
  install.packages("knitr")

if (!requireNamespace("ggplot2", quietly = TRUE))
  install.packages("ggplot2")

if (!requireNamespace("caret", quietly = TRUE))
  install.packages("caret")

if (!requireNamespace("extrafont", quietly = TRUE))
  install.packages("extrafont")

if (!requireNamespace("reshape", quietly = TRUE))
  install.packages("reshape")

if (!requireNamespace("tidyverse", quietly = TRUE))
  install.packages("tidyverse")


#=========================================#
##              Load packages            ##
#=========================================#

library(ggplot2)

library(reshape)
library(rstudioapi)
library(tidyverse)

# Normalisation
library(caret)
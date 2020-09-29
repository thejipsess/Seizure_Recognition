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

# Data Mining and Analysis of Lipidomics Datasets (used for is probabilistic quotient normalisation)
if (!requireNamespace("lipidr", quietly = TRUE))
  BiocManager::install("lipidr")

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

if (!requireNamespace("pca3d", quietly = TRUE))
  install.packages("pca3d")


#=========================================#
##              Load packages            ##
#=========================================#

library(ggplot2)
library(pca3d)

library(reshape)
library(rstudioapi)
library(tidyverse)

# Normalisation
library(caret)
library(lipidr)
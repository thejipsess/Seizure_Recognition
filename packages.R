#=========================================#
##       Install missing packages        ##
#=========================================#

# Update all packages
#update.packages()

# Install backports and devtools, and load devtools such that github packages can be installed
if (!requireNamespace("backports", quietly = TRUE))
  install.packages("backports")
#if (!requireNamespace("devtools", quietly = TRUE))
#  install.packages("devtools", dependencies = TRUE)
#library(devtools)

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
  install.packages("caret", dependencies = TRUE)

if (!requireNamespace("extrafont", quietly = TRUE))
  install.packages("extrafont")

if (!requireNamespace("reshape", quietly = TRUE))
  install.packages("reshape")

if (!requireNamespace("dplyr", quietly = TRUE))
  install.packages("dplyr")

if (!requireNamespace("tidyverse", quietly = TRUE))
  install.packages("tidyverse")

if (!requireNamespace("rgl", quietly = TRUE))
  install.packages("rgl")

if (!requireNamespace("pca3d", quietly = TRUE))
  install.packages("pca3d")

#if (!requireNamespace("ggbiplot", quietly = TRUE))
#  install_github("vqv/ggbiplot")

if (!requireNamespace("kernlab", quietly = TRUE))
  install.packages("kernlab")

if (!requireNamespace("tidymodels", quietly = TRUE))
  install.packages("tidymodels")

if (!requireNamespace("modelr", quietly = TRUE))
  install.packages("modelr")

if (!requireNamespace("doParallel", quietly = TRUE))
  install.packages("doParallel")


#=========================================#
##              Load packages            ##
#=========================================#

library(ggplot2)
#library(ggbiplot)
library(rgl)
library(pca3d)

library(modelr)
library(reshape)
library(rstudioapi)
library(tidyverse)
library(tidymodels)
library(kernlab)
library(doParallel)

# Normalisation
library(caret)

# SVM
library(e1071)

#=========================================#
##             Load local files          ##
#=========================================#
source("plotter.R")
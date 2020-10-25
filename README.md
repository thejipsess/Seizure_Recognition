# Seizure_Recognition
 Code to predict seizure from brain activity
 This code was developed under R version 4.0.2 64 bit so make sure to use this version and install Rtools.
 
 This repository contains code, which pre-processes EEG data and optimises and trains an SVM model to predict whether a seizure is occuring based on the EEG data.
 
 # The files
 main.Rmd: this is the main script, written in R markdown, which is the only script you need to run.
 
 packages.R: this script is loaded by main.Rmd and install all the required packages that are not yet installed on your computer. Also it loads the required packages and it loads the function in plotter.R and classification.R
 
 plotter.R: this file contains various plotting functions which are used in main.R. The reason they are put in this file is to keep the code in main.R cleaner.
 
 classification.R: this file contains functions used in the classification process which are called from from main.Rmd.
 
 # Notes
 
 - In case that packages.R isn't able to install a specific packages, try installing it manuallt in RStudio via Tools->Install Packages...
 - If you get the error "Error in loadNamespace(name) : there is no package called ‘knitr’" then run: install.packages("knitr")
 - If any other errors pop up about missing packages, install them manually in R studio via Tools->Install packagess...
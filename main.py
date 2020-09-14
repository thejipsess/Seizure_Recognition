# -*- coding: utf-8 -*-
"""
Created on Thu Sep  3 14:49:20 2020

@author: The Jipsess
"""

# The data used here is EEG data. Originally there were 500 participants, who
# were recorded for 23.5 seconds with 4097 data points per sample. Each sample
# was divided into 23 chunks , each containing 178 data points for 1 second.
# These chunks were shuffled, resulting in 11500 samples.
#
# 
# 5 - eyes open, means when they were recording the EEG signal of the brain the patient had their eyes open
# 4 - eyes closed, means when they were recording the EEG signal the patient had their eyes closed
# 3 - Yes they identify where the region of the tumor was in the brain and recording the EEG activity from the healthy brain area
# 2 - They recorder the EEG from the area where the tumor was located
# 1 - Recording of seizure activity

import os
import numpy as np
import pandas as pd

from sklearn import preprocessing as pp
from sklearn.covariance import EllipticEnvelope as mcd

from matplotlib import pyplot as plt

os.chdir("D:/OneDrive/school/1. Master/11. Scientific Programming/Github/Seizure_Recognition")

x = pd.read_csv("Data/data.csv", sep = ";")


# %% Data inspection
# Count number of missing values
nullsum = np.sum(np.sum(x.isnull()))

# Set all alternative classes to class zero
# 0 = no seizure -- 1 = seizure
x['y'].loc[x['y'] != 1] = 0

# Let's inspect the distribution of the data
plt.hist(x['X1'], bins = 200, histtype = 'barstacked')
plt.show()

fig, axes = plt.figure()
plt.hist(x.iloc[:,1:3], 20, histtype='step', stacked=True, fill=False)

plt.hist(x['X1'], 100, alpha = 0.5, label='a')
plt.hist(x['X2'], 100, alpha = 0.5, label='b')
plt.legend(loc='upper left')

plt.show()

for col in x.columns[1:-1]:
    plt.hist(x[col], 100, alpha = 0.5)

plt.show()

# Visualise noise
plt.figure(dpi = 300)
for i in range(80,82):
    plt.plot(x.iloc[i,1:-1], alpha = 0.75, linewidth=0.2)
plt.show()

plt.figure(dpi = 300)
plt.plot(x.iloc[105,1:-1], marker ='x', markersize=3)
plt.show()

# %% Data Cleaning

# Set variable names colummn as index
x.set_index('Unnamed: 0', inplace = True)

# == Missing Data ==
# Remove all samples with any missing data
x.dropna(inplace = True)

# == Noise Removal ==


# == Outlier Detection ==
cov = mcd(support_fraction = 0.6, random_state = 0).fit(x)
outliers = cov.predict(x)
num_outliers = np.unique(outliers, return_counts=True)
# %% Data  Transformation
# Data Normilisation
y = pp.normalize(x)

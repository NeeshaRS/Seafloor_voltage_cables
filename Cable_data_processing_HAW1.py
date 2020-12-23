#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec  5 10:35:46 2018

@author: neeshaschnepf
"""

import scipy.io as sio
import scipy.signal as sig
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt

# Load in the cable data files ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ 

timed = sio.loadmat('/Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/Cable_data_processing/HAW1NS/HAW1_1hr_timedata.mat')
haw1n = timed['HAW1N_voltdata']
time = timed['timedata']
haw1s = timed['HAW1S_voltdata']

# Clean the cable data based on the AP index ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ ~~ 

def F_Remove_Ap20(Raw_cable_data,timeseries, maxindex):
    # This function removes data on days where the Ap index >= maxindex
    # INPUTS:
        # Raw_cable_data: this is the input of raw cable data with noise present
        # timeseries: this is the corresponding array of date/time info
        # maxindex: the max allowed Ap index
    # OUTPUTS:
        # clean_data: the data with NaNs filling days that have Ap >= maxindex
    
    # Load in the Ap indices and corresponding dates
    ApDates = sio.loadmat('/Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/Ap_Index_Dates.mat')
    Dates= ApDates['Date']
    ApI = sio.loadmat('/Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/Ap_index.mat')
    Ap= ApI['Ap']
    # Get the indices of the noisy days (Days where the Ap index is >= maxindex)
    noisyind= np.where(Ap > maxindex)
    noisy= noisyind[0]
    # Get the dates of the noisy days
    noisydays= Dates[noisy]
    # Remove the noisy days by setting them to nans
    cleandata = Raw_cable_data
    dayhour=24
    n= noisydays.size
    for i in range (1,n)
        spot=np.where(noisydays[i] == floor(timeseries));
        clean_data[range(spot,spot+dayhour)]= nan;
    return clean_data

def F_Remove_Tides(data_array,t):
    # This function fits for the main 12 tidal modes that are within ~24 hr period and then 
    # subtracts them from the data to remove the tidal signal. 
    # INPUTS:
        # data_array: this is the input of raw cable data with noise present
        # t: this is the corresponding array of date/time info
    # OUTPUTS:
        # clean_data: the data with the tidal signals subtracted out
   
   # define the tidal periods 
   periods = np.array([4, 4.8, 6, 8, 11.967236, 12, 12.421, 12.6583, 23.934472, 24, 24.066, 25.891])
   
   # create the models
   x=np.array([cos(2*pi*t/(periods[0]/24)), sin(2*pi*t/(periods[0]/24))])
   n= periods.size
   for j in range (2,n)
       x=np.array([x, cos(2*pi*t/(periods[j]/24)), sin(2*pi*t/(periods[j]/24))])

   # now I need to figure out how to convert Matlab's robustfit function into a python thing
   # because the next step is to do a robust least-squares fit to get the amplitudes and phases
   # of the tidal signals
   
   # then I create a synthetic tidal signal time series and subtract that from the data
   
   return clean_data

def F_Clean_Cable_Data(Raw_cable_data, timeseries, maxindex):
    # This function cleans the data by removing days with AP >= maxindex and removing
    # solar/lunar tidal signals
    # INPUTS:
        # Raw_cable_data: this is the input of raw cable data with noise present
        # timeseries: this is the corresponding array of date/time info
        # maxindex: the max value of the Ap index
    # OUTPUTS:
        # clean_data: this is the output clean data
        # compare: this is the percentage of clean data compared to original data
    
    #1-- Remove days where AP index >= maxindex
    data_APcleaned= F_Remove_Ap20(Raw_cable_data,timeseries, maxindex)
    #2-- Remove solar and lunar tides
    clean_data= F_Remove_Tides(data_APcleaned,timeseries)
    #3-- Determine percentage relating how much of the original data has been kept
    originalNaNs= np.isnan(Raw_cable_data)
    NoOriginalDataPoints= np.size(originalNaNs) - np.sum(originalNaNs)
    newNans= np.isnan(clean_data)
    NoCleanDataPoints= np.size(newNans) - np.sum(newNans)
    compare= 100*(NoCleanDataPoints/NoOriginalDataPoints)
    print("data cleaned; percent of original:",  compare)

    return clean_data
    
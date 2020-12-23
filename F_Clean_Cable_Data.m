function [clean_data,compare]= F_Clean_Cable_Data(Raw_cable_data,timeseries, maxindex);
% This function cleans the data by removing days with AP >= 20 and removing
% solar/lunar tidal signals
% INPUTS:
%   Raw_cable_data: this is the input of raw cable data with noise present
%   timeseries: this is the corresponding array of date/time info
%   maxindex: the max value of the Ap index
% OUTPUTS:
%   clean_data: this is the output clean data
%   compare: this is the percentage of clean data compared to original data


% 1-- Remove days where AP index >= maxindex
[data_APcleaned]= F_Remove_Ap20(Raw_cable_data,timeseries, maxindex);

% 2-- Remove solar and lunar tides
[clean_data]= F_Remove_Tides(data_APcleaned,timeseries);

% Percentage relating how much of the original data has been kept
originalNaNs=isnan(Raw_cable_data);
NoOriginalDataPoints=length(originalNaNs)-sum(originalNaNs);
newNaNs=isnan(clean_data);
NoCleanDataPoints=length(newNaNs)-sum(newNaNs);
compare=100*NoCleanDataPoints/NoOriginalDataPoints; 
disp('data cleaned; percent of original:')
disp(compare)
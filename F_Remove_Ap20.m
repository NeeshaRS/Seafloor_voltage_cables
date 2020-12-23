function [clean_data]= F_Remove_Ap20(Raw_cable_data,timeseries, maxindex)
% Raw_cable_data: this is the input of raw cable data with noise present
% timeseries: this is the corresponding array of date/time info
% clean_data: the data with NaNs filling days that have Ap >= 20

addpath /Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/
load Ap_Index_Dates.mat; load Ap_index.mat;
% Get the indices of the noisy days (Days where the Ap index is >=20)
Noisy_day_ind=find(Ap>=maxindex);
% Get the dates
Noisy_days=Date(Noisy_day_ind);

clean_data=Raw_cable_data;

dayhour=24;

% Set all the noisy days to NaN
for i=1:length(Noisy_days)
   spot=find(floor(timeseries)==Noisy_days(i));
   clean_data(spot:spot+dayhour-1)=NaN;
end
function [clean_data]= F_Remove_Tides(data_array,t)
% data_array: this is the input of raw cable data with noise present
% t: this is the corresponding array of date/time info
% clean_data: the data with the tidal signals subtracted out
 
% define tidal periods
periods = [4 4.8 6 8 11.967236 12 12.421 12.6583 23.934472 24 24.066 25.891]; % ... 
  %  13.6334*24 327.8599 24*14.7653 661.3090];
 
% create a model
x=[cos(2*pi*t(:)/(periods(1)/24) ) sin(2*pi*t(:)/(periods(1)/24) )];
for j=2:length(periods)
   x=[x cos(2*pi*t(:)/(periods(j)/24) ) sin(2*pi*t(:)/(periods(j)/24) )]; 
end
 
% fit with the data
[s,stats] = robustfit(x, data_array);
 
% determine the amplitudes (A) and phases (P)
A = abs(complex(s(2:2:end),s(3:2:end)));
P = atan(s(3:2:end)./s(2:2:end)); % -1*

% create the synthetic time series
for i = 1:length(P),
    yy(i,:) = A(i)*sin(2*pi*t*24./periods(i) + P(i));
end;
 
% remove the modelled time series
clean_data = data_array - s(1) + sum(yy);
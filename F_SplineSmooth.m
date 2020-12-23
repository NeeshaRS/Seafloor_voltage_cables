function [smoothed_data,time_array]= F_SplineSmooth(Cable_data,timeseries, knot_length)
% Inputs:
% Cable_data: this is the input of cable data
% timeseries: this is the corresponding array of date/time info
% knot_length = length of knots for spline fit
% Outputs:
% smoothed_data: the data fit by the spline

% Remove NaNs from consideration
temp = isnan(Cable_data);
data_array = Cable_data(~temp);
time_array = timeseries(~temp);

% define knots (in days)
b1 = min(time_array):knot_length:max(time_array)+10;

if length(b1) > 1,
    sp=spline(b1,data_array(:)'/spline(b1,eye(length(b1)),time_array(:)')); % spline fit
end;

smoothed_data=ppval(time_array,sp);
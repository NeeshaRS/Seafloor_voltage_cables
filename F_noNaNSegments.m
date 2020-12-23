function [ data_segments ] = F_noNaNSegments( data, time)
% F_noNaNSegments: This breaks a data series (and its corresponding time
% series) into multiple segments that are all free of NaNs so it can then
% be used in a frequency-based filter.
%   INPUTS:
%       data- the data series
%       time- the time series
%   OUTPUTS:
%       data_segments- a structure that has each of the corresponding data
%       and time series NaN-free segments

% find the NaNs
test=isnan(data);
temp=[0 diff(test)];

% Find where data segments start
dataS= find(temp== -1);
% Find where data segments end
dataE= find(temp== 1); % this gives where NaN segments start
dataE= dataE - 1; % this shifts the index back to the last data point before the NaN

n= length(dataS)
for i=1:n
    data_segments.data{i}= data(dataS(i):dataE(i));
    data_segments.time{i}= time(dataS(i):dataE(i));
end

end


function [ data_lpf, time_lpf ] = F_BWfilter( data_segments, minperiod)
%F_BWfilter: Use a butterworth low pass filter on a data segment
%   INPUTS:
%   data_segmentss- a structure that has each of the corresponding data
%   minperiod- the minimum period, given in seconds

% The butterworth filter
dt= 3600; % The sample rate of one per hour
w = dt*2.0/minperiod;
n = 7;
[B, A] = butter(n,w,'low');

% Determine the number of segments
sizeD=size(data_segments.data);
n = sizeD(2);

data_lpf=[];
time_lpf=[];

for i=1:n
    % check if the segment is long enough
    sD=size(data_segments.data{i});
    if sD(2) > 48 % Make sure there are at least 2 consecutive days of data
        % filter the segment & add it to the array of filtered data & the
        % corresponding times
        lpfd = filtfilt(B,A, data_segments.data{i});
        data_lpf=[data_lpf lpfd];
        time_lpf=[time_lpf data_segments.time{i}];
    end
end

end


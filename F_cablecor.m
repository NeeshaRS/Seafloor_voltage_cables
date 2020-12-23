function [ R, R2 ] = F_cablecor( data, pred, dtime, ptime, sp, ep)
%F_cablecor Determine the correlation or autocorrelation between the
% prediction and the processed cable data

% INPUTS:
%   data- the data time series
%   pred- the prediction time series
%   dtime- the data time 
%   ptime- the prediction time
%   sp- the time starting point
%   ep- the time ending point

% OUTPUTS:
%   R- the matrix of correlation coefficients
%   R2- the R squared value
%-----------------------------------------------------------------------------------------
%% Pick the correct start/end points of the prediction to match the cable data 

% Find closest point in data to sp
[c spi] = min(abs(dtime-sp));
% Find closest point in data to ep
[c epi] = min(abs(dtime-ep));

% Resize the data time series
data = data(spi:epi);
dtime= dtime(spi:epi);

% Find closest point in prediction to sp
[c spi] = min(abs(ptime-sp));
% Find closest point in prediction to ep
[c epi] = min(abs(ptime-ep));

% Resize the prediction time series
pred = pred(spi:epi);
ptime= ptime(spi:epi);

% Interpolate data to match prediction series
dataq = interp1(dtime,data,ptime);

% Remove NaNs
test= isnan(dataq);
pred(test)=[];
dataq(test)=[];
ptime(test)=[];

%  whos dataq ptime pred

%% Determine the correlation matrix
R = corrcoef(dataq,pred);

%% Determine the R-squared value
% calculate the residuals
residuals = dataq - pred;
% calculate the total sum of squares (proportional to the variance of the data)
SStot = sum((dataq-mean(dataq)).^2);
% calculate the regression sum of squares
SSreg = sum((pred-mean(dataq)).^2);
% calculate the residual sum of squares
SSres = sum((residuals).^2);
% calculate R^2
R2 = 1 - SSres/SStot;
end


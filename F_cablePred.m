function [ V ] = F_cablePred(Ep, Et,  time,  cable_choice, res)
% Compute the cable voltages from the simulated electric field
% INPUTS:
% Ep & Et: the predicted electric field results in the phi and theta
% components
% time: the time stamp of each model prediction
% cable_choice: the cable being evaluated,  options 1-13
% 1: AMK
% 2: OKI
% 3: PG
% 4: MG
% 5: HAW1N
% 6: HAW1S
% 7: HAW3
% 8: TPC1
% 9: TPC2
% 10: GRH1
% 11: GRH2
% 12: TKN1
% 13: TKN2
% 14: NG
% res: the resolution- 1 for 1 degree resolution and 2 for half degree
% resolution
% OUTPUTS:
% V: the cable's predicted voltage

%% The cables

latitudes1 = [30.2, 35.2, 15.8, 28.2, 38.9, 38.9, 35.3, 28.2, 13.6, 41.4, 41.4, 39.6, 39.6, 35.2];
latitudes2 = [32.5, 26.5, 13.6, 13.6, 21.5, 21.5, 21.5, 21.5, 21.5, 36.4, 36.4, 50.1, 50.1, 13.6];
longitudes1 = [128.2, 139.2, 121.6, 177.4, -123.7, -123.7, -120.7, 177.4, 144.9, -71.6, -71.6, -74.3, -74.3, 139.2];
longitudes2 = [130.1, 127.9, 144.9, 144.9, -158.2, -158.2, -158.2, -158.2, -158.2, -5.1, -5.1, -5.7, -5.7, 144.9];

clat = [latitudes1(cable_choice),  latitudes2(cable_choice)];
clon = [longitudes1(cable_choice),  longitudes2(cable_choice)];

%% Compute the cable's voltage
n=length(time);
V=zeros(n,1);

for i=1:n
    % the following are divided by 1000 to convert from mV to V
    [Vp, r1, lat, lon] = mapprofile(flipud(squeeze(Ep(i, :, :)))/1000, [res, 90, 0], clat, clon); 
    [Vt, r1, lat, lon] = mapprofile(flipud(squeeze(Et(i, :, :)))/1000, [res, 90, 0], clat, clon);
    
    % Position / distance vector
    pvec = [diff(clat), diff(clon)];
    pvec = pvec/(sqrt(sum(pvec.^2)));
    pvec = repmat(pvec', [1, length(Vp)])';
    
    dvec = [Vt Vp];
    
    sc = dot(pvec', dvec');
    
    V(i) = trapz(deg2km(r1), sc);
end

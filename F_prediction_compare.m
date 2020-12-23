function [  ] = F_prediction_compare(x3dg,  time,  cable_choice)
%Compute Voltages from ECCO simulated electric field and compare with
%measured voltages from submarine cables.
% INPUTS:
% x3dg: the predicted electric field results
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

%input
cable_choice = 1; %1-13

%-------------------------------------------------------------------------%

cable_names = {'AMK', 'OKI', 'PG', 'MG', 'HAW1N', 'HAW1S', 'HAW3', 'TPC1', 'TPC2', ...
    'GRH1', 'GRH2', 'TKN1', 'TKN2'}; %Add HAW2 once location is known

filenames = {'AMK.mat', 'OKI.mat', 'GUM.mat', 'GUM.mat', 'PTA.mat', 'PTA.mat', ...
    'MAK.mat', 'MAK.mat', 'MAK.mat', 'GRH.mat', 'GRH.mat', 'TKN.mat', 'TKN.mat'};

titles = {'Shanghai-Amakusa', 'Ninomiya-Okinawa', 'Philippines-Guam', ...
    'Midway-Guam', 'Point Arena, CA-Hanauma Bay,  HI', 'Point Arena, CA-Hanauma Bay,  HI', ...
    'San Luis Obispo, CA-Makaha, HI', 'Midway-Makaha, HI', 'Guam-Makaha, HI', ...
    'TAT5: Rhode Island-Spain', 'TAT5: Rhode Island-Spain', 'TAT7: New Jersey-England', ...
    'TAT7: New Jersey-England'};

latitudes1 = [30.2, 35.2, 15.8, 28.2, 38.9, 38.9, 35.3, 28.2, 13.6, 41.4, 41.4, 39.6, 39.6 35.2];
latitudes2 = [32.5, 26.5, 13.6, 13.6, 21.5, 21.5, 21.5, 21.5, 21.5, 36.4, 36.4, 50.1, 50.1 13.6];
longitudes1 = [128.2, 139.2, 121.6, 177.4, -123.7, -123.7, -120.7, 177.4, 144.9, -71.6, -71.6, -74.3, -74.3 139.2];
longitudes2 = [130.1, 127.9, 144.9, 144.9, -158.2, -158.2, -158.2, -158.2, -158.2, -5.1, -5.1, -5.7, -5.7 144.9];

clat = [latitudes1(cable_choice),  latitudes2(cable_choice)];
clon = [longitudes1(cable_choice),  longitudes2(cable_choice)];

%load the simulated Electric field from ECCO 1992-2004 fields and measured
%cable voltages
load /nfs/satmag_work/mnair/projects/ocean/ECCO_Annual_Simulation/ecco1x1_comp_fields.mat Et Ep; 
load /nfs/satmag_work/mnair/projects/ocean/ECCO_Annual_Simulation/IUIV199.mat timeaxU;
TimeID = timeaxU;
load(filenames{cable_choice})

dateE = TimeID/(3600*24) + datenum(1992, 1, 1, 6, 0, 0); % 1992 Jan 1,  6 AM is the starting point

for i = 1:156;

    [Vp, r1, lat, lon] = mapprofile(flipud(squeeze(Ep(i, :, :)))/1000, [1, 90, 0], clat, clon); %divided by 1000 to convert from mV to V

    [Vt, r1, lat, lon] = mapprofile(flipud(squeeze(Et(i, :, :)))/1000, [1, 90, 0], clat, clon);

    pvec = [diff(clat), diff(clon)];

    pvec = pvec/(sqrt(sum(pvec.^2))); 

    pvec = repmat(pvec', [1, length(Vp)])';

    dvec = [Vt Vp];

    sc = dot(pvec', dvec'); 

    Vol(i) = trapz(deg2km(r1), sc); 

end;

%plot

timetemp = eval([cable_names{cable_choice}, '_time_array']);
volttemp = eval([cable_names{cable_choice}, '_spline']);

plot(dateE, Vol, 'r', 'LineWidth', 2)
hold on
plot(timetemp, volttemp, 'b', 'LineWidth', 2)
legend('ECCO-Predicted', 'Measured')
datetick('x', 'keeplimits')
ylabel('Volts')
titlestr = titles{cable_choice};
title(titlestr)


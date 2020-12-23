function [ transport ] = F_cablePred_transportv2(cable_choice)
% Compute the transport across the cables from the ECCOv2 transports

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
% 15: Drake Passage Test

% OUTPUTS:
% T: the predicted cross cable transport

%% The cables

latitudes1 = [30.2, 35.2, 15.8, 28.2, 38.9, 38.9, 35.3, 28.2, 13.6, 41.4, 41.4, 39.6, 39.6, 35.2 -63.40];
latitudes2 = [32.5, 26.5, 13.6, 13.6, 21.5, 21.5, 21.5, 21.5, 21.5, 36.4, 36.4, 50.1, 50.1, 13.6 -54.95];
longitudes1 = [128.2, 139.2, 121.6, 177.4, -123.7, -123.7, -120.7, 177.4, 144.9, -71.6, -71.6, -74.3, -74.3, 139.2 -57.19];
longitudes2 = [130.1, 127.9, 144.9, 144.9, -158.2, -158.2, -158.2, -158.2, -158.2, -5.1, -5.1, -5.7, -5.7, 144.9 -65.10];

clat = [latitudes1(cable_choice),  latitudes2(cable_choice)];
clon = [longitudes1(cable_choice),  longitudes2(cable_choice)];
cvec = [(longitudes1(cable_choice)-longitudes2(cable_choice)); (latitudes1(cable_choice) - latitudes2(cable_choice))];

%% Compute the transport across the cable
load ECCO_v2/IU-IV-Source-iter199.mat

dimensions=size(IU1);
n=dimensions(3);
transport=zeros(n,1);

for i=1:n
    tempE=flipud(reshape(IU1(:,:,i),[180 360]));
    tempN=flipud(reshape(IV1(:,:,i),[180 360]));
    
    % If R is a referencing vector, it must be a 1-by-3 with elements:
    % [cells/degree northern_latitude_limit western_longitude_limit]
    R= [1 90 0];
    [tE, r1, lat, lon] = mapprofile(flipud(tempE), R, clat, clon);
    [tN, r1, lat, lon] = mapprofile(flipud(tempN), R, clat, clon);
    
%     figure(1); plot(tE)
%     figure(2); plot(tN)
%     disp('transports determined')
    
    tvec=[tE'; tN'];
    % Determine transport perpedicular to cable path.
    crossv = [-cvec(2) cvec(1)];
    crossv = crossv/(sqrt(sum(crossv.^2)));
    crossv = repmat(crossv', [1, length(tE)])';
    
    trans = dot(crossv', tvec);
    transport(i) = trapz(deg2km(r1)*1e3, trans); % convert degrees to meters, not km
end

disp('transports computed')

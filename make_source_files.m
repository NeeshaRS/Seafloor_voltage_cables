clc; clear all; close all;

% Load in relevant IGRF files for main field
load ../Main_Bz/IGRF_endpoints.mat

%% Load in ECCO velocities
load ../ECCO/IU-IV-Source-iter199.mat

IU=flipud(IU1(:,:,1));
IV=flipud(IV1(:,:,1));

%% Create electric currents
% Load in laterally variable depth averaged conductivity
load /Users/neeshaschnepf/RESEARCH/Data/Ocean_Water_Conductivity/Manojs_Method/DAC_2001.mat

dac=flipud(dac');

CUr0= IU.*Br0.*dac;
CVr0= IV.*Br0.*dac;
CUrE= IU.*BrE.*dac;
CVrE= IV.*BrE.*dac;

CUi= zeros(size(CUr0));
CVi= zeros(size(CVr0));

CUr0(isnan(CUr0))=0;
CVr0(isnan(CVr0))=0;
CUrE(isnan(CUrE))=0;
CVrE(isnan(CVrE))=0;

disp('currents made')

%% Plot the electric currents
load coast;

fig1 = figure(1); 
set(fig1,'Position',[0 0 1500 700],'PaperPositionMode','auto'); % Set figure size

subplot(321); 
imagesc(CUr0,[-.04 .04]); 
title('Re[CU0]'); set(gca, 'FontSize', 15); 
xlabel('Longitude (Degrees)'); ylabel('Colatitude (Degrees)');
h=colorbar('peer',gca); 
hold on; plot([long,360+long], (90-lat), '-k','LineWidth',2);

subplot(322); 
imagesc(CVr0,[-.04 .04]);
title('Re[CV0]'); set(gca, 'FontSize', 15); 
xlabel('Longitude (Degrees)'); ylabel('Colatitude (Degrees)');
h=colorbar('peer',gca); 
hold on; plot([long,360+long], (90-lat), '-k','LineWidth',2);

subplot(323); 
imagesc(CUrE,[-.04 .04]);
title('Re[CUE]'); set(gca, 'FontSize', 15); 
xlabel('Longitude (Degrees)'); ylabel('Colatitude (Degrees)');
h=colorbar('peer',gca); 
hold on; plot([long,360+long], (90-lat), '-k','LineWidth',2);

subplot(324); 
imagesc(CVrE,[-.04 .04]);
title('Re[CVE]'); set(gca, 'FontSize', 15); 
xlabel('Longitude (Degrees)'); ylabel('Colatitude (Degrees)');
h=colorbar('peer',gca); 
hold on; plot([long,360+long], (90-lat), '-k','LineWidth',2);


subplot(325); 
imagesc(CUr0-CUrE);
title('Re[CU0]-Re[CUE]'); set(gca, 'FontSize', 15); 
xlabel('Longitude (Degrees)'); ylabel('Colatitude (Degrees)');
h=colorbar('peer',gca); 
hold on; plot([long,360+long], (90-lat), '-k','LineWidth',2);

subplot(326); 
imagesc(CVr0-CVrE);
title('Re[CV0]-Re[CVE]'); set(gca, 'FontSize', 15); 
xlabel('Longitude (Degrees)'); ylabel('Colatitude (Degrees)');
h=colorbar('peer',gca); 
hold on; plot([long,360+long], (90-lat), '-k','LineWidth',2);

%% Make the source file
% For Br0
fid0 = fopen(['/Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/Make_Source_Files/ECCOm1_dac2001_Br0.source'],'wt');
% For BrE
fidE = fopen(['/Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/Make_Source_Files/ECCOm1_dac2001_BrE.source'],'wt');


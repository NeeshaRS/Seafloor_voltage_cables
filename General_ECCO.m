clc; clear all; close all;

load ECCO_1992_2004_E_simulation.mat 
%% To get a cable's predicted voltage
% 1: AMK
% 2: OKI
% 3: PG
% 4: MG
% 5: HAW1N
% 6: HAW1S
% 7: HAW3
% 8: TPC1
% 9: TPC2
% 14: NG

[ V_AMK ] = F_cablePred(Ep, Et,  TimeAxis, 1);

% save file
% save Predicted_AMK_V.mat V_AMK TimeAxis
disp('saved')
%% For plots of each time step
F_x3dgResults(Ep, TimeAxis, 'E')
%% Get depth integrated velocities
clc; clear all; close all;
load IUIV199.mat
load ECCO_1992_2004_E_simulation.mat 

[ transport ] = F_cablePred_transport(IU, IV,  TimeAxis, 15);

plot(transport/1e6)
%%
% save HAW3_transport.mat transport TimeAxis

mU=mean(IU,3);
mV=mean(IV,3);

mC = (mU.^2 + mV.^2).^.5;

[Xo, Yo] = meshgrid(YU,XU);
[Xi, Yi] = meshgrid(YU,[-89.5:89.5]');
mCinterp = interp2(Xo, Yo, mC, Xi, Yi);

whos
%% Plot the temporal-mean depth integrated velocity & the cables
map = [
        0.2510         0    0.2510
    0.2331         0    0.3045
    0.2151         0    0.3580
    0.1972         0    0.4115
    0.1793         0    0.4650
    0.1613         0    0.5185
    0.1434         0    0.5720
    0.1255         0    0.6255
    0.1076         0    0.6790
    0.0896         0    0.7325
    0.0717         0    0.7860
    0.0538         0    0.8395
    0.0359         0    0.8930
    0.0179         0    0.9465
         0         0    1.0000
    0.0091    0.0909    1.0000
    0.0182    0.1818    1.0000
    0.0273    0.2727    1.0000
    0.0364    0.3636    1.0000
    0.0455    0.4545    1.0000
    0.0545    0.5455    1.0000
    0.0636    0.6364    1.0000
    0.0727    0.7273    1.0000
    0.0818    0.8182    1.0000
    0.0909    0.9091    1.0000
    0.1000    1.0000    1.0000
    0.2500    1.0000    1.0000
    0.4000    1.0000    1.0000
    0.5500    1.0000    1.0000
    0.7000    1.0000    1.0000
    0.8500    1.0000    1.0000
    1.0000    1.0000    1.0000];
colormap(flipud(map));

fig1=figure(1);
worldmap([-70,70], [120,260]); hold on; 
set(gca, 'FontSize', 18); 
load geoid
geoshow(mCinterp, geoidrefvec, 'DisplayType', 'texturemap');
load coastlines; plotm(coastlat,coastlon,'k'); 
h=colorbar('peer',gca); caxis([0 360]); hold on;
set(h,'fontsize',14); set(get(h,'ylabel'),'string','m^2/s','fontsize',18);


% cables
latitudes1 = [30.2, 35.2, 15.8, 28.2, 38.9, 38.9, 35.3, 28.2, 13.6, 41.4, 41.4, 39.6, 39.6 35.2];
latitudes2 = [32.5, 26.5, 13.6, 13.6, 21.5, 21.5, 21.5, 21.5, 21.5, 36.4, 36.4, 50.1, 50.1 13.6];
longitudes1 = [128.2, 139.2, 121.6, 177.4, -123.7, -123.7, -120.7, 177.4, 144.9, -71.6, -71.6, -74.3, -74.3 139.2];
longitudes2 = [130.1, 127.9, 144.9, 144.9, -158.2, -158.2, -158.2, -158.2, -158.2, -5.1, -5.1, -5.7, -5.7 144.9];

% 1: AMK
% geoshow(([30.2 32.5]),[128.2 130.1],'LineWidth',2,'Color','black');
% 2: OKI
geoshow([(26.5) (35.2)],[127.9 139.2],'LineWidth',2,'Color','k');
textm(25,130,'OKI','FontSize',16);
% 4: MG
% geoshow(( [latitudes1(4) latitudes2(4)]), [longitudes1(4) longitudes2(4)],'LineWidth',2,'Color','black');
% 5: HAW1N
geoshow(( [38.9 21.5]), (360+[-123.7 -158.2]),'LineWidth',2,'Color','black');
textm(40,211,'HAW1','FontSize',16);
% 7: HAW3
geoshow(( [35.3 21.5]), (360+[-120.7 -158.2]),'LineWidth',2,'Color','black');
textm(25,220,'HAW3','FontSize',16);
% 8: TPC1
% geoshow(( [latitudes1(8) latitudes2(8)]), [longitudes1(8) 360+longitudes2(8)],'LineWidth',2,'Color','black');
% 9: TPC2
% geoshow(( [latitudes1(9) latitudes2(9)]), [longitudes1(9) 360+longitudes2(9)],'LineWidth',2,'Color','black');
% 14: NG
% geoshow(( [latitudes1(14) latitudes2(14)]), [longitudes1(14) longitudes2(14)],'LineWidth',2,'Color','black');

print -dpng  'Mean_Transport_Cables.png';
%% Plot the temporal-mean electric field & the cables
mEp = mean(Ep,1); mEp = reshape(mEp,180,360);
mEt = mean(Et,1); mEt = reshape(mEt,180,360);

mE=(mEp.^2 + mEt.^2).^.5;

%%
map = [1.0000    1.0000    1.0000
    1.0000    1.0000    0.8333
    1.0000    1.0000    0.6667
    1.0000    1.0000    0.5000
    1.0000    1.0000    0.3333
    1.0000    1.0000    0.1667
    1.0000    1.0000         0
    1.0000    0.9333         0
    1.0000    0.8667         0
    1.0000    0.8000         0
    1.0000    0.7333         0
    1.0000    0.6667         0
    1.0000    0.6000         0
    1.0000    0.5333         0
    1.0000    0.4667         0
    1.0000    0.4000         0
    1.0000    0.3333         0
    1.0000    0.2667         0
    1.0000    0.2000         0
    1.0000    0.1333         0
    1.0000    0.0667         0
    1.0000         0         0
    1.0000         0    0.0909
    1.0000         0    0.1818
    1.0000         0    0.2727
    1.0000         0    0.3636
    1.0000         0    0.4545
    1.0000         0    0.5455
    1.0000         0    0.6364
    1.0000         0    0.7273
    1.0000         0    0.8182
    1.0000         0    0.9091
    1.0000         0    1.0000];
colormap(map);

fig1=figure(1); set(fig1,'Position',[100 100 1000 700],'PaperPositionMode','auto');
worldmap([10,50], [120,260]); hold on; 
set(gca, 'FontSize', 18); 
load geoid
geoshow(mE, geoidrefvec, 'DisplayType', 'texturemap');
load coastlines
h=colorbar; caxis([0 2]); 
set(h,'fontsize',14); set(get(h,'ylabel'),'string','mV/km','fontsize',18);
plotm(coastlat,coastlon,'k'); 

% cables
latitudes1 = [30.2, 35.2, 15.8, 28.2, 38.9, 38.9, 35.3, 28.2, 13.6, 41.4, 41.4, 39.6, 39.6 35.2];
latitudes2 = [32.5, 26.5, 13.6, 13.6, 21.5, 21.5, 21.5, 21.5, 21.5, 36.4, 36.4, 50.1, 50.1 13.6];
longitudes1 = [128.2, 139.2, 121.6, 177.4, -123.7, -123.7, -120.7, 177.4, 144.9, -71.6, -71.6, -74.3, -74.3 139.2];
longitudes2 = [130.1, 127.9, 144.9, 144.9, -158.2, -158.2, -158.2, -158.2, -158.2, -5.1, -5.1, -5.7, -5.7 144.9];

% 1: AMK
% geoshow(([30.2 32.5]),[128.2 130.1],'LineWidth',2,'Color','black');
% 2: OKI
geoshow([(26.5) (35.2)],[127.9 139.2],'LineWidth',2,'Color','k');
textm(26,130,'OKI','FontSize',18);
% 4: MG
% geoshow(( [latitudes1(4) latitudes2(4)]), [longitudes1(4) longitudes2(4)],'LineWidth',2,'Color','black');
% 5: HAW1N
geoshow(( [38.9 21.5]), (360+[-123.7 -158.2]),'LineWidth',2,'Color','black');
textm(39,214,'HAW1','FontSize',18);
% 7: HAW3
geoshow(( [35.3 21.5]), (360+[-120.7 -158.2]),'LineWidth',2,'Color','black');
textm(32,230,'HAW3','FontSize',18);
% 8: TPC1
% geoshow(( [latitudes1(8) latitudes2(8)]), [longitudes1(8) 360+longitudes2(8)],'LineWidth',2,'Color','black');
% 9: TPC2
% geoshow(( [latitudes1(9) latitudes2(9)]), [longitudes1(9) 360+longitudes2(9)],'LineWidth',2,'Color','black');
% 14: NG
% geoshow(( [latitudes1(14) latitudes2(14)]), [longitudes1(14) longitudes2(14)],'LineWidth',2,'Color','black');

print -dpng  'Mean_E_Cables.png';
disp('saved')
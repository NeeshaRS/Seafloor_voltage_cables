clc; clear all; close all;
load ECCO_1992-2015_Transports.mat
%%
meanE= mean(transE,3);
meanN= mean(transN,3);

fig1=figure(1);%-----------------------------------
set(fig1,'Position',[100 100 1000 500],'PaperPositionMode','auto');
colormap(F_redblue);
worldmap([0,70], [120,310]); hold on; 
load geoid
meanE=[meanE(:,181:end) meanE(:,1:180)];
geoshow(flipud(meanE), geoidrefvec, 'DisplayType', 'texturemap');
load coastlines; plotm(coastlat,coastlon,'k'); 
h=colorbar('peer',gca); caxis([-50 50]);
set(h,'fontsize',14); set(get(h,'ylabel'),'string','m^2/s','fontsize',18);
set(gca, 'FontSize', 18); 

% 2: OKI
geoshow([(26.5) (35.2)],[127.9 139.2],'LineWidth',2,'Color','k');
textm(25,130,'OKI','FontSize',14);
% 5: HAW1N
geoshow(( [38.9 21.5]), (360+[-123.7 -158.2]),'LineWidth',2,'Color','black');
textm(40,211,'HAW1','FontSize',14);
% 7: HAW3
geoshow(( [35.3 21.5]), (360+[-120.7 -158.2]),'LineWidth',2,'Color','black');
textm(25,220,'HAW3','FontSize',14);
% 14: NG
% geoshow([(13.6) (35.2)],[144.9 139.2],'LineWidth',2,'Color','k');
% textm(17,146,'NG','FontSize',14);

print -dpng  'ECCOv4_E_Transport_Cables.png';
%%
fig1=figure(2);%-----------------------------------
set(fig1,'Position',[100 100 1000 500],'PaperPositionMode','auto');
colormap(F_redblue);
worldmap([0,70], [120,310]); hold on; 
set(gca, 'FontSize', 18); 
load geoid
meanN=[meanN(:,181:end) meanN(:,1:180)];
geoshow(flipud(meanN), geoidrefvec, 'DisplayType', 'texturemap');
load coastlines; plotm(coastlat,coastlon,'k'); 
h=colorbar('peer',gca); caxis([-50 50]);
set(h,'fontsize',14); set(get(h,'ylabel'),'string','m^2/s','fontsize',18);

% 2: OKI
geoshow([(26.5) (35.2)],[127.9 139.2],'LineWidth',2,'Color','k');
textm(25,130,'OKI','FontSize',14);
% 5: HAW1N
geoshow(( [38.9 21.5]), (360+[-123.7 -158.2]),'LineWidth',2,'Color','black');
textm(40,211,'HAW1','FontSize',14);
% 7: HAW3
geoshow(( [35.3 21.5]), (360+[-120.7 -158.2]),'LineWidth',2,'Color','black');
textm(25,220,'HAW3','FontSize',14);
% 14: NG
% geoshow([(13.6) (35.2)],[144.9 139.2],'LineWidth',2,'Color','k');
% textm(17,146,'NG','FontSize',14);

print -dpng  'ECCOv4_N_Transport_Cables.png';

%% plot all cables
fig1=figure(2);%-----------------------------------
set(fig1,'Position',[100 100 1000 500],'PaperPositionMode','auto');
% load Pacific
h= worldmap([0,70], [110,300]); hold on; 
% geoshow(h, map, refvec, 'DisplayType', 'texturemap')
% demcmap(map)
land = shaperead('landareas.shp', 'UseGeoCoords', true);
geoshow(land, 'FaceColor', [0.15 0.5 0.15])

set(gca, 'FontSize', 18); 
load geoid
load coastlines; plotm(coastlat,coastlon,'k'); 

% 2: OKI
geoshow([(26.5) (35.2)],[127.9 139.2],'LineWidth',2,'Color','k');
textm(25,130,'OKI','FontSize',14);
% 5: HAW1N
geoshow(( [38.9 21.5]), (360+[-123.7 -158.2]),'LineWidth',2,'Color','black');
textm(40,211,'HAW1','FontSize',14);
% 7: HAW3
geoshow(( [35.3 21.5]), (360+[-120.7 -158.2]),'LineWidth',2,'Color','black');
textm(25,220,'HAW3','FontSize',14);

print -dpng  'All_Cables_Map.png';
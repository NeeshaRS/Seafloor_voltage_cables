clc; clear all; close all;
%%
addpath /Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/Pacific/OKI/
load OKI_timedata.mat
load OKI_voltdata.mat
%% Downsample to once per hour
OKI_voltdata= OKI_voltdata(1:60:end);
timedata= timedata(1:60:end);

disp('downsampled')
%% Clean the data
[OKI_clean_data,compare]= F_Clean_Cable_Data(OKI_voltdata,timedata);

disp('data cleaned')

%% Smooth the data for long term trends
knot_length=90;

[OKI_smoothed,stime3]= F_SplineSmooth(OKI_clean_data,timedata, knot_length);
disp('data smoothed')

%% Plot of splined data
h2=figure(2); dateFormat = 11;
plot(stime3,OKI_smoothed,'k-o'); hold on;
datetick('x',dateFormat); set(gca,'FontSize',16);
xlim([datenum('January 1 1999') datenum('March 1 2002')])
xlabel('Year'); ylabel('Voltage (V)'); title('OKI Cable');

% print('OKI_Obs_Spline','-dpng');
%% Save the processed data
save OKI_Processed_Data_90days.mat stime3 OKI_smoothed
disp('saved')
%% Plot of processed data vs predicted data
close all;
load OKI/OKI_Processed_Data_90days.mat
% load OKI/OKI_Processed_Data_30p5days.mat

% load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/Cable_Predictions.mat
% x3dg_OKI = V_OKI; x3dg_time = time;

% load CablePred_JelmgTD_30min_1997-2001.mat
load Cable_Transect_Predictions.mat
elmgTD_OKI = V_OKI; elmgTD_time = time;

% load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/ECCO_v2/Predicted_OKI_V.mat
% v2_OKI= V_OKI; v2_time= TimeAxis;
whos

knot_length=90;
% knot_length=30.5;
% [V_OKIO_smoothed,stimeO]= F_SplineSmooth(v2_OKI,v2_time, knot_length);
[elmgTD_smoothed,estime]= F_SplineSmooth(elmgTD_OKI,elmgTD_time, knot_length);
% [x3dg_smoothed,xstime]= F_SplineSmooth(x3dg_OKI,x3dg_time, knot_length);

% PREDICTION & DATA PLOT
h2=figure(2); dateFormat = 11;
% set(h2,'Position',[10 10 1000 500],'PaperPositionMode','auto');
% PLOT THE VOLTAGES
% subplot(211)
plot(stime3, OKI_smoothed,'k-o','LineWidth',2); hold on;

% plot(v2_time, v2_OKI+1,'k--o','LineWidth',2);
% plot(stimeO, V_OKIO_smoothed,'k--o','LineWidth',2);

% plot(x3dg_time, x3dg_OKI+1,'r','LineWidth',2);
% plot(xstime,x3dg_smoothed+1, 'r','LineWidth',2);

% plot(elmgTD_time, elmgTD_OKI+1.8,'--r','LineWidth',2); 
plot(estime, elmgTD_smoothed+1.8,'--r','LineWidth',2); 

datetick('x',dateFormat); set(gca,'FontSize',16);
% legend('OKI minus 1','ECCOv4r3','ECCO-GODAEi199','Location','southoutside','Orientation','horizontal')
legend('OKI','ECCOv4r3-elmgTD+1.8','Location','southoutside','Orientation','horizontal')
xlim([stime3(1) stime3(end)])
xlabel('Year'); ylabel('Voltage (V)'); 

% print('OKI/OKI_90day_ECCOv4_elmgTD_hires_1999-2001','-dpng');
% print('OKI/OKI_30p5day_ECCOv4_elmgTD_hires_1999-2001','-dpng');
%% Correlation scatter plots

% [ h1, pred, ptime ] = F_corplot(OKI_smoothed, elmgTD_smoothed, stime3, estime); % 30.5 DAY SPLINES
[ h1, pred, ptime ] = F_corplot(OKI_smoothed, elmgTD_smoothed, stime3, estime); % 90 DAY SPLINES 

%% Get correlation info

% first interpolate predictions to be as fine resolution as observation
predinterp = interp1(ptime,pred,stime3);

temp=isnan(predinterp);

predinterp(temp)=[];
stime3(temp)=[];
OKI_smoothed(temp)=[];

[R,P, RL, RU] = corrcoef(OKI_smoothed,predinterp)
%% Make ASCII file for Jakub

load Cable_coords.mat

fileID = fopen(['/Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/HiResInfo_OKI.txt'],'wt');

disp('opened')
fprintf(fileID,'%20s %12s %12s\n','date','colat', 'lon');

disp('starting loop')
% loop across the coordinates
tic
for i= 1:length(OKI_coords)
    % loop across the time points
    for t= 1:length(stime3)
        fprintf(fileID,'%20s %12.8f %12.8f\n', datestr(stime3(t)), (90-OKI_coords(i,1)), OKI_coords(i,2));
    end
end
fclose(fileID);
toc
disp('written out')
%% Cable versus prediction correlation
clc
sp= stime3(1);
ep= stime3(end);
[ R, R2 ] = F_cablecor(OKI_smoothed, elmgTD_OKI, stime3, elmgTD_time, sp, ep)
% [ R, R2 ] = F_cablecor(OKI_smoothed, V_OKIO_smoothed, stime3, stimeO, sp, ep)
%% PLOT THE TRANSPORT
% subplot(212)
close all
h2=figure(2); dateFormat = 11; set(gca,'FontSize',16);
yyaxis left
plot(stime3, OKI_smoothed,'-o');
ylabel('Voltage (V)');

yyaxis right
plot(TimeAxis,transport/1e6,'LineWidth',2); 
ylabel('Transport (Sv)'); datetick('x',dateFormat); set(gca,'FontSize',16);
legend('OKI','Transport Prediction','Location','southoutside','Orientation','horizontal')
xlim([datenum('January 1 1999') datenum('March 1 2002')]); xlabel('Year'); 

% print('OKI_Cleaned_ECCO_V_Sv_Compare','-dpng');
print('OKI_Cleaned_ECCO_Sv_Compare','-dpng');
disp('saved')

%% plot for poster
load OKI/OKI_Processed_Data.mat
figure(1)
subplot(311)
plot(timedata, OKI_voltdata,'k'); dateFormat = 11; datetick('x',dateFormat);
xlim([datenum('January 1 1999') datenum('March 1 2002')])
set(gca,'FontSize',16);
xlabel('Year'); ylabel('Voltage (V)'); title('OKI Raw');

subplot(312)
plot(timedata, OKI_clean_data,'k'); dateFormat = 11; datetick('x',dateFormat);
xlim([datenum('January 1 1999') datenum('March 1 2002')])
set(gca,'FontSize',16);
xlabel('Year'); ylabel('Voltage (V)'); title('OKI Cleaned');

subplot(313)
plot(stime3,OKI_smoothed,'k'); dateFormat = 11; datetick('x',dateFormat);
xlim([datenum('January 1 1999') datenum('March 1 2002')])
set(gca,'FontSize',16);
xlabel('Year'); ylabel('Voltage (V)'); title('OKI Smoothed');

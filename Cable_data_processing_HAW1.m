clc; clear all; close all;

%% HAW1
addpath /Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/Pacific/HAW1/
load HAW_1hr_timedata.mat
load HAW1NS/Corrected_HAW1N.mat

%% Clean the data
maxindex = 5;
[HAW1N_clean_data,compare]= F_Clean_Cable_Data(HAW1N_voltdata_C,timedata, maxindex);
[HAW1S_clean_data,compare]= F_Clean_Cable_Data(HAW1S_voltdata,timedata, maxindex);

disp('data cleaned')
%% Butterworth filter the data
% Break the data series into segments that are NaN free
[ data_segments ] = F_noNaNSegments( HAW1N_clean_data, timedata)
disp('Broken into NaN-free segments')
% Examine the power spectra of the longest continuous segment
[minV, maxV, index, segPSD ] = F_segPSD( data_segments )

%% First low pass filter test
minperiod = 7*24*60*60; % 7 day minimum period given in seconds
[ data_lpf, time_lpf ]  = F_BWfilter( data_segments, minperiod);
disp('low pass filter run')

figure(1); dateFormat = 11;
plot(time_lpf,data_lpf)
datetick('x',dateFormat); set(gca,'FontSize',16);
%% Smooth the data for long term trends using a moving-average
k=24*30; % time window
test = movmean(HAW1N_clean_data,k,'omitnan');
figure(2); plot(test);

%% Smooth the data for long term trends using splines
knot_length=90;
[HAW1N_smoothed,stime1N]= F_SplineSmooth(HAW1N_clean_data,timedata, knot_length);
[HAW1S_smoothed,stime1S]= F_SplineSmooth(HAW1S_clean_data,timedata, knot_length);

disp('data smoothed')
%% Plot of processed data
h2=figure(1); dateFormat = 11;
plot(stime1N,HAW1N_smoothed,'b');
hold on;
plot(stime1S,HAW1S_smoothed,'k'); 
datetick('x',dateFormat); set(gca,'FontSize',16);
legend('HAW1N','HAW1S','Location','NorthEast')
xlim([datenum('January 1 1997') datenum('January 1 1999')])
% ylim([-30 15])
xlabel('Year'); ylabel('Voltage (V)'); title('HAW1 Cables');
%% Save the processed data
save HAW1NS/max_Ap5/HAW1N_Processed_Data_90days.mat stime1N HAW1N_smoothed stime1S HAW1S_smoothed
disp('saved')
%% Plot of processed data vs predicted data
% load HAW1NS/max_Ap20/HAW1N_Processed_Data_90days.mat
load HAW1NS/max_Ap20/HAW1N_Processed_Data_30p5days.mat
% load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/Cable_Predictions.mat
% x3dg_HAW1 = V_HAW1; x3dg_time = time;

load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/ECCO_v2/Predicted_HAW1N_V.mat
v2_HAW1 = V_HAW1N; v2time= TimeAxis;

% load CablePred_JelmgTD_30min_1997-2001.mat 
load Cable_Transect_Predictions.mat
elmgTD_HAW1 = V_HAW1; elmgTD_time = time;

close all

% knot_length=90;
knot_length=30.5;
% [x3dg_smoothed,sxtime]= F_SplineSmooth(x3dg_HAW1,x3dg_time, knot_length);
[elmgTD_smoothed,setime]= F_SplineSmooth(elmgTD_HAW1,elmgTD_time, knot_length);
% [v2_smoothed,v2stime]= F_SplineSmooth(v2_HAW1,v2time, knot_length);

whos
% hold on
%% Make ASCII file for Jakub
for i=1
    load Cable_coords.mat
    
    fileID = fopen(['/Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/HiResInfo_HAW1.txt'],'wt');
    
    disp('opened')
    fprintf(fileID,'%20s %12s %12s\n','date','colat', 'lon');
    
    disp('starting loop')
    % loop across the coordinates
    tic
    for i= 1:length(HAW1_coords)
        % loop across the time points
        for t= 43161:length(stime1N)
            fprintf(fileID,'%20s %12.8f %12.8f\n', datestr(stime1N(t)), (90-HAW1_coords(i,1)), HAW1_coords(i,2));
        end
    end
    fclose(fileID);
    toc
    disp('written out')
end
%%
h2=figure(2); dateFormat = 11;
% set(h2,'Position',[10 10 800 500],'PaperPositionMode','auto');
% PLOT THE VOLTAGES
plot(stime1N,HAW1N_smoothed,'b','LineWidth',2); hold on;
plot(stime1S,HAW1S_smoothed,'k','LineWidth',2); 

% plot(v2time,v2_HAW1,'k--o','LineWidth',2);
% plot(v2stime,v2_smoothed,'k--o','LineWidth',2);

% plot(x3dg_time,x3dg_HAW1,'r','LineWidth',2); 
% plot(sxtime,x3dg_smoothed,'r','LineWidth',2); 

% plot(elmgTD_time, elmgTD_HAW1,'--r','LineWidth',2);
plot(setime, elmgTD_smoothed,'--r','LineWidth',2);
% ylim([-.5 .4])
ylabel('Voltage (V)'); datetick('x',dateFormat); set(gca,'FontSize',16);
xlim([datenum('January 1 1997') datenum('February 28 1999')]); xlabel('Year'); 
% legend('HAW1N','HAW1S','ECCOv4r3','ECCO-GODAEi199','Location','southoutside','Orientation','horizontal')
legend('HAW1N','HAW1S','ECCOv4r3-elmgTD','Location','southoutside','Orientation','horizontal')

% print -dpng 'HAW1NS/max_Ap20/HAW1_30p5day_ECCOv4_elmgTD_hires_1997-1999.png'
% print -dpng 'HAW1NS/max_Ap20/HAW1_90day_ECCOv4_elmgTD_hires_1997-1999.png'
%%
[ h1, pred, ptime ] = F_corplot(HAW1S_smoothed, elmgTD_smoothed, stime1N, setime)
%% Get correlation info

% first interpolate predictions to be as fine resolution as observation
predinterp = interp1(ptime,pred,stime1N,'nearest');

temp=isnan(predinterp);

predinterp(temp)=[];
stime1N(temp)=[];
HAW1S_smoothed(temp)=[];
HAW1N_smoothed(temp)=[];

clc
disp('HAW1N')
[R,P] = corrcoef(HAW1N_smoothed,predinterp)
disp('HAW1S')
[R,P] = corrcoef(HAW1S_smoothed,predinterp)
%% Cable versus prediction correlation
clc
sp= datenum('January 16 1992');
ep= datenum('December 15 1997');
[ R, R2 ] = F_cablecor(HAW1N_smoothed, V_HAW1_smoothed, stime1N, stime, sp, ep)
[ R, R2 ] = F_cablecor(HAW1N_smoothed, V_HAW1N_smoothed, stime1N, stimeN, sp, ep)

%% Cable correlation plots

% The Cleaned Data
h3=figure(3);
plot(HAW1N_clean_data,HAW1S_clean_data,'o');
set(gca,'FontSize',16); % ylim([-30 20]); xlim([-30 20]);
xlabel('HAW1N'); ylabel('HAW1S'); title('Correlation scatter plot');

% The Cleaned Data
h3=figure(3);
plot(HAW1N_clean_data,HAW1S_clean_data,'o');

% plot(HAW1S_clean_data,HAW1S_clean_data,'o');
set(gca,'FontSize',16); % ylim([-30 20]); xlim([-30 20]);
xlabel('HAW1N'); ylabel('HAW1S'); title('Correlation scatter plot');

%% The Smoothed Data
h4=figure(4);
plot(HAW1N_smoothed,HAW1S_smoothed,'o');
set(gca,'FontSize',16); % ylim([-30 20]); xlim([-30 20]);
xlabel('HAW1N'); ylabel('HAW1S'); title('Correlation scatter plot');

%% plot for poster
load HAW1NS/HAW1N_Processed_Data.mat
load HAW1NS/HAW1_1hr_timedata.mat
load HAW1NS/Corrected_HAW1N.mat
figure(1)
subplot(311)
plot(timedata, HAW1N_voltdata_C,'r'); hold on;
plot(timedata, HAW1S_voltdata,'k');
dateFormat = 11; datetick('x',dateFormat);
xlim([datenum('January 1 1990') datenum('January 1 2000')]); xlabel('Year'); 
set(gca,'FontSize',16);
ylabel('Voltage (V)'); title('HAW1 Raw');
legend('HAW1N','HAW1S','Location','northoutside','Orientation','horizontal')

subplot(312)
plot(timedata, HAW1N_clean_data,'r'); hold on;
plot(timedata, HAW1S_clean_data,'k');
dateFormat = 11; datetick('x',dateFormat);
xlim([datenum('January 1 1990') datenum('January 1 2000')]); xlabel('Year'); 
set(gca,'FontSize',16); ylabel('Voltage (V)'); title('HAW1 Cleaned');
legend('HAW1N','HAW1S','Location','northoutside','Orientation','horizontal')

subplot(313)
plot(stime1N,HAW1N_smoothed,'r'); hold on;
plot(stime1S,HAW1S_smoothed,'k')
dateFormat = 11; datetick('x',dateFormat);
xlim([datenum('January 1 1990') datenum('January 1 2000')]); xlabel('Year'); 
set(gca,'FontSize',16);  ylabel('Voltage (V)'); title('HAW1 Smoothed');
legend('HAW1N','HAW1S','Location','northoutside','Orientation','horizontal')

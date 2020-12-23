clc; clear all; close all;

addpath /Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/Pacific/GUM/
load GUM_timedata.mat
load MG_voltdata.mat
%% Trim the arrays

% Remove spike window
s0 = 5095095;
MG_voltdata(s0:end) = NaN;

% Remove weird flatline
s1 = 3266109;
s2 = 3745461;

MG_voltdata(s1:s2) = NaN;
%% Downsample to once per hour
MG_voltdata= MG_voltdata(1:60:end);
timedata= timedata(1:60:end);

disp('downsampled')
%% Clean the data
tic
[MG_clean_data,compare]= F_Clean_Cable_Data(MG_voltdata,timedata);
toc

s1 = 68231; s2 = 69409;
MG_clean_data(s1:s2) = NaN;

disp('data cleaned')
%% Smooth the data for long term trends
knot_length=90;

[MG_smoothed,stime3]= F_SplineSmooth(MG_clean_data,timedata, knot_length);
disp('data smoothed')

%% Plot of processed / cleaned data
h2=figure(2); dateFormat = 11;
% plot(timedata,MG_clean_data,'k-o'); hold on; % plot the cleaned data
plot(stime3,MG_smoothed,'k-o'); hold on; % plot the processed data
datetick('x',dateFormat); set(gca,'FontSize',16);
xlim([datenum('January 1 1995') datenum('January 1 2000')])
xlabel('Year'); ylabel('Voltage (V)'); title('MG Cable');

% print('MG_Cleaned','-dpng'); % save the cleaned data
print('MG_Obs','-dpng'); % save the processed data
%% Save the processed data
save MG_Processed_Data.mat stime3 MG_smoothed
disp('saved')
%% Plot of processed data vs predicted data
close all;
load MG_Processed_Data.mat
load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/Cable_Predictions.mat
knot_length=90;
[V_MG_smoothed,stime]= F_SplineSmooth(V_MG,time, knot_length);
load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/ECCO_v2/Predicted_MG_V.mat
[V_MGO_smoothed,stimeO]= F_SplineSmooth(V_MG,TimeAxis, knot_length);

h2=figure(2); dateFormat = 11;
plot(stime3, MG_smoothed,'k-o'); hold on;
plot(stime, V_MG_smoothed,'r','LineWidth',3); 
plot(stimeO, V_MGO_smoothed,'--r','LineWidth',3); 
datetick('x',dateFormat); set(gca,'FontSize',16);
legend('MG','New V Pred','Old V Pred','Location','SouthEast')
xlim([datenum('January 1 1995') datenum('January 1 2000')])
xlabel('Year'); ylabel('Voltage (V)'); 

print('MG_ECCO_v2-v4compare_90days','-dpng');
disp('saved')
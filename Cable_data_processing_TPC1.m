clc; clear all; close all;

addpath /Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/Pacific/
load MAK_1hr_timedata.mat
load TPC1_1hr_voltdata.mat

%% Clean the data
[TPC1_clean_data,compare]= F_Clean_Cable_Data(TPC1_voltdata,timedata);

% Remove the bizarre spike
x1 = 54982;
x2 = 54996;
TPC1_clean_data(x1:x2) = NaN;
disp('data cleaned')
%% Recenter the data to zero since it looks like during the data gap the voltage got reset to a higher amount

s1 = 58896;
s2 = 62377;
se = 88296;

TPC1_clean_data(1:s1) = TPC1_clean_data(1:s1) + .5;
TPC1_clean_data(s2:se) = TPC1_clean_data(s2:se) - .4;
TPC1_clean_data(se:end)= NaN;
disp('shifted first segment of data')

plot(timedata, TPC1_clean_data); dateFormat = 11; datetick('x',dateFormat);
%% Smooth the data for long term trends using splines
knot_length=90;
[TPC1_smoothed,stime]= F_SplineSmooth(TPC1_clean_data,timedata, knot_length);

disp('data smoothed')
%% Plot of processed data
h2=figure(2); dateFormat = 11;
plot(stime,TPC1_smoothed,'k-o'); hold on;
datetick('x',dateFormat); set(gca,'FontSize',16);
xlim([datenum('January 1 1994') datenum('January 1 2001')])
xlabel('Year'); ylabel('Voltage (V)'); title('TPC1 Cable');

print('TPC1_Obs','-dpng');
%% Save the processed data
save TPC1_Processed_Data.mat stime TPC1_smoothed
disp('saved')
%% Plot of processed data vs predicted data
load TPC/TPC1_Processed_Data.mat
load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/Cable_Predictions.mat
knot_length=90;
[V_TPC1_smoothed,stime1]= F_SplineSmooth(V_TPC1,time, knot_length);
load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/ECCO_v2/Predicted_TPC1_V.mat
[V_TPC1O_smoothed,stime1O]= F_SplineSmooth(V_TPC1,TimeAxis, knot_length);

h2=figure(1); dateFormat = 11;
plot(stime,TPC1_smoothed,'k-o'); hold on;
hold on;
plot(stime1,V_TPC1_smoothed,'r','LineWidth',2);
plot(stime1O,V_TPC1O_smoothed,'--r','LineWidth',2);
datetick('x',dateFormat); set(gca,'FontSize',16);
legend('TPC1','New V Pred','Old V Pred','Location','NorthWest','orientation','horizontal')
xlim([stime(1) stime(end)]); ylim([-.15 .11])
xlabel('Year'); ylabel('Voltage (V)');

print('TPC1_Obs_ECCO_v2-v4Compare_90days','-dpng');
disp('saved')
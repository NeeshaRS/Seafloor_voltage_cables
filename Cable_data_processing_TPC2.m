clc; clear all; close all;

addpath /Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/Pacific/
load MAK_1hr_timedata.mat
load TPC2_1hr_voltdata.mat

%% Clean the data
[TPC2_clean_data,compare]= F_Clean_Cable_Data(TPC2_voltdata,timedata);

disp('data cleaned')

%% Smooth the data for long term trends using splines
knot_length=90;
[TPC2_smoothed,stime]= F_SplineSmooth(TPC2_clean_data,timedata, knot_length);

disp('data smoothed')
%% Plot of processed data
h2=figure(2); dateFormat = 11;
plot(stime,TPC2_smoothed,'k-o'); hold on;
datetick('x',dateFormat); set(gca,'FontSize',16);
xlim([datenum('January 1 1994') datenum('January 1 2001')])
xlabel('Year'); ylabel('Voltage (V)'); title('TPC2 Cable');

print('TPC2_Obs','-dpng');
%% plot for poster
load TPC/TPC2_Processed_Data.mat
figure(1)
subplot(311)
plot(timedata, TPC2_voltdata,'k'); dateFormat = 11; datetick('x',dateFormat);
xlim([datenum('January 1 1994') datenum('January 1 2001')]); 
set(gca,'FontSize',16);
xlabel('Year'); ylabel('Voltage (V)'); title('TPC2 Raw');

subplot(312)
plot(timedata, TPC2_clean_data,'k'); dateFormat = 11; datetick('x',dateFormat);
xlim([datenum('January 1 1994') datenum('January 1 2001')]); 
set(gca,'FontSize',16);
xlabel('Year'); ylabel('Voltage (V)'); title('TPC2 Cleaned');

subplot(313)
plot(stime,TPC2_smoothed,'k'); dateFormat = 11; datetick('x',dateFormat);
xlim([datenum('January 1 1994') datenum('January 1 2001')]); 
set(gca,'FontSize',16);
xlabel('Year'); ylabel('Voltage (V)'); title('TPC2 Smoothed');

%% Save the processed data
save TPC2_Processed_Data.mat stime TPC2_smoothed
disp('saved')
%% Plot of processed data vs predicted data
load TPC/TPC2_Processed_Data.mat
load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/Cable_Predictions.mat
knot_length=90;
[V_TPC2_smoothed,stime2]= F_SplineSmooth(V_TPC2,time, knot_length);
load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/ECCO_v2/Predicted_TPC2_V.mat
[V_TPC2O_smoothed,stime2O]= F_SplineSmooth(V_TPC2,TimeAxis, knot_length);

h2=figure(1); dateFormat = 11;
plot(stime,TPC2_smoothed,'k-o'); hold on;
hold on;
plot(stime2,V_TPC2_smoothed,'r','LineWidth',2);
plot(stime2O,V_TPC2O_smoothed,'--r','LineWidth',2);
datetick('x',dateFormat); set(gca,'FontSize',16);
legend('TPC2','New V Pred','Old V Pred','Location','NorthWest','orientation','horizontal')
xlim([stime(1) stime(end)])
xlabel('Year'); ylabel('Voltage (V)');

print('TPC2_Obs_ECCO_v2-v4Compare_90days','-dpng');
disp('saved')
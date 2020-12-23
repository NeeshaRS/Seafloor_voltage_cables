clc; clear all; close all;

addpath /Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/Pacific/GUM/
load GUM_timedata.mat
load NG_voltdata.mat
%% Trim the arrays
% Remove weird things
s1 = 85783; s2 = 85799;
NG_voltdata(s1:s2) = NaN;

s1= 85944; s2= 86443;
NG_voltdata(s1:s2) = NaN;

s1= 86542; s2= 86545;
NG_voltdata(s1:s2) = NaN;

s1= 87047; s2= 87049;
NG_voltdata(s1:s2) = NaN;

s1= 87536; s2= 87578;
NG_voltdata(s1:s2) = NaN;

s1= 88121; s2= 88124;
NG_voltdata(s1:s2) = NaN;

s1= 88467; s2= 88469;
NG_voltdata(s1:s2) = NaN;

s1= 88623; s2= 88638;
NG_voltdata(s1:s2) = NaN;

temp=find(NG_voltdata > 5000 | NG_voltdata < 3000 );
NG_voltdata(temp)= NaN;
%% Downsample to once per hour
NG_voltdata= NG_voltdata(1:60:end);
timedata= timedata(1:60:end);

disp('downsampled')
%% Fix baseline shifts
s1= 56457; s2= 56521;
NG_voltdata(s1:s2) = NaN;

s1= 61646; s2= 61647;
NG_voltdata(1:s1)=NG_voltdata(1:s1)-nanmean(NG_voltdata(1:s1));
NG_voltdata(s2:end)=NG_voltdata(s2:end)-nanmean(NG_voltdata(s2:end));
disp('shifted')
%% Clean the data
tic
[NG_clean_data,compare]= F_Clean_Cable_Data(NG_voltdata,timedata);
toc

disp('data cleaned')
%% Smooth the data for long term trends
knot_length=90;

[NG_smoothed,stime3]= F_SplineSmooth(NG_clean_data,timedata, knot_length);
disp('data smoothed')

%% Plot of processed data
h2=figure(2); dateFormat = 11;
plot(stime3,NG_smoothed,'k-o'); hold on;
datetick('x',dateFormat); set(gca,'FontSize',16);
xlim([datenum('January 1 1995') datenum('January 1 2003')])
xlabel('Year'); ylabel('Voltage (V)'); title('NG Cable');

print('NG_Obs','-dpng');
%% Save the processed data
save NG_Processed_Data.mat stime3 NG_smoothed
disp('saved')
%% Plot of processed data vs predicted data
close all;
load NG/NG_Processed_Data.mat
load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/Cable_Predictions.mat
knot_length=90;
[V_NG_smoothed,stime]= F_SplineSmooth(V_NG,time, knot_length);
load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/ECCO_v2/Predicted_NG_V.mat
[V_NGO_smoothed,stimeO]= F_SplineSmooth(V_NG,TimeAxis, knot_length);

h2=figure(2); dateFormat = 11;
plot(stime3, NG_smoothed,'k-o'); hold on;
plot(stime, V_NG_smoothed,'r','LineWidth',3);
plot(stimeO, V_NGO_smoothed,'--r','LineWidth',3);
datetick('x',dateFormat); set(gca,'FontSize',16);
legend('NG','New V Pred','Old V Pred','Location','SouthEast')
xlim([datenum('January 1 1995') datenum('January 1 2003')])
xlabel('Year'); ylabel('Voltage (V)'); 

print('NG_ECCO_v2-v4compare_90days','-dpng');
disp('saved')
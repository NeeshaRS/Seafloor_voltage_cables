clc; clear all; close all;

addpath /Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/Pacific/AMK/
load AMK_timedata.mat
load AMK_voltdata.mat
%% Trim the arrays
s1=4698965;
s2=6311520;

AMK_voltdata= AMK_voltdata(s1:s2);
timedata= timedata(s1:s2);

%% Downsample to once per hour
AMK_voltdata= AMK_voltdata(1:60:end);
timedata= timedata(1:60:end);

disp('downsampled')
%% Clean the data
tic
[AMK_clean_data,compare]= F_Clean_Cable_Data(AMK_voltdata,timedata);
toc

% remove the enormous spikes
n=length(AMK_clean_data);
for i=1:n
    if abs(AMK_clean_data(i)) >= 5
       AMK_clean_data(i) = NaN ;
    end
end

disp('data cleaned')
%% Smooth the data for long term trends
knot_length=90;

[AMK_smoothed,stime3]= F_SplineSmooth(AMK_clean_data,timedata, knot_length);
disp('data smoothed')

%% Plot of processed data
h2=figure(2); dateFormat = 11;
plot(stime3,AMK_smoothed,'k-o'); hold on;
datetick('x',dateFormat); set(gca,'FontSize',16);
xlim([datenum('December 1 1998') datenum('January 1 2002')])
xlabel('Year'); ylabel('Voltage (V)'); title('AMK Cable');

print('AMK_Obs','-dpng');
%% Save the processed data
save AMK_Processed_Data.mat stime3 AMK_smoothed
disp('saved')
%% Plot of processed data vs predicted data
close all;
load AMK/AMK_Processed_Data.mat
load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/Cable_Predictions.mat
knot_length=90;
[V_AMK_smoothed,stime]= F_SplineSmooth(V_AMK,time, knot_length);
load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/ECCO_v2/Predicted_AMK_V.mat
[V_AMKO_smoothed,stimeO]= F_SplineSmooth(V_AMK,TimeAxis, knot_length);

h2=figure(2); dateFormat = 11;
plot(stime3, AMK_smoothed,'k-o'); hold on;
plot(stime, V_AMK_smoothed-.2,'r','LineWidth',3); 
plot(stimeO, V_AMKO_smoothed,'--r','LineWidth',3); 
datetick('x',dateFormat); set(gca,'FontSize',16);
legend('AMK','New V Pred - 0.2','Old V Pred','Location','NorthEast')
xlim([datenum('December 1 1998') datenum('January 1 2002')])
xlabel('Year'); ylabel('Voltage (V)'); 

print('AMK_Obs_ECCO_v2-v4compare_90days','-dpng');
disp('saved')
clc; clear all; close all;

%% HAW3
load /Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/Pacific/MAK_1hr_timedata.mat
load /Users/neeshaschnepf/RESEARCH/Data/Seafloor_Cables/Pacific/HAW3_1hr_voltdata.mat

%% Clean the data
[HAW3_clean_data,compare]= F_Clean_Cable_Data(HAW3_voltdata, timedata, 20);

s1= 44514;
s2= 44805;

HAW3_clean_data(s1:s2) = NaN;

disp('data cleaned')
%% Smooth the data for long term trends
knot_length=90;

[HAW3_smoothed,stime3]= F_SplineSmooth(HAW3_clean_data,timedata, knot_length);
disp('data smoothed')

%% Plot of processed data
h2=figure(2); dateFormat = 11;
% plot(timedata,HAW3_voltdata)
% plot(timedata,HAW3_clean_data)
plot(stime3,HAW3_smoothed,'k-o'); hold on;
datetick('x',dateFormat); set(gca,'FontSize',24);
xlim([datenum('January 1 1997') datenum('January 1 2001')])
ylim([-.3 .3])
xlabel('Year'); ylabel('Voltage (V)'); title('c)','FontSize',30);

% print('HAW3/HAW3_A_Obs_Raw','-dpng');
% print('HAW3/HAW3_A_Obs_Raw','-deps');

% print('HAW3/HAW3_B_Obs_Cleaned','-dpng');
% print('HAW3/HAW3_B_Obs_Cleaned','-deps');

print('HAW3/HAW3_C_Obs_Smoothed','-dpng');
print('HAW3/HAW3_C_Obs_Smoothed','-deps');
%% Save the processed data
save HAW3_Processed_Data_30p5days.mat stime3 HAW3_smoothed
disp('saved')
%% Plot of processed data vs predicted data
close all;
% load HAW3/HAW3_Processed_Data_90days.mat
load HAW3/HAW3_Processed_Data_30p5days.mat
% load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/Cable_Predictions.mat
% x3dg_HAW3 = V_HAW3; x3dg_time = time;

% load CablePred_JelmgTD_30min_1997-2001.mat 
load Cable_Transect_Predictions.mat
elmgTD_HAW3 = V_HAW3; elmgTD_time = time;

% load /Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/ECCO/ECCO_v2/Predicted_HAW3_V.mat
% V_HAW3v2= V_HAW3; timev2= TimeAxis;
whos

% knot_length=90;
knot_length=30.5;
% [x3dg_smoothed,sxtime]= F_SplineSmooth(x3dg_HAW3, x3dg_time, knot_length);
[elmg_smoothed,setime]= F_SplineSmooth(elmgTD_HAW3, elmgTD_time, knot_length);
% [V_HAW3O_smoothed,stimeO]= F_SplineSmooth(V_HAW3,TimeAxis, knot_length);
%% Make ASCII file for Jakub

for i=1
    load Cable_coords.mat
    
    fileID = fopen(['/Users/neeshaschnepf/RESEARCH/Ocean_mag/Circulation/Cables/HiResInfo_HAW3.txt'],'wt');
    
    disp('opened')
    fprintf(fileID,'%20s %12s %12s\n','date','colat', 'lon');
    
    disp('starting loop')
    % loop across the coordinates
    tic
    for i= 1:length(HAW3_coords)
        % loop across the time points
        for t= 14764:length(stime3)
            fprintf(fileID,'%20s %12.8f %12.8f\n', datestr(stime3(t)), (90-HAW3_coords(i,1)), HAW3_coords(i,2));
        end
    end
    fclose(fileID);
    toc
    disp('written out')
end
%%
h2=figure(2); dateFormat = 11;
plot(stime3(14905:end), HAW3_smoothed(14905:end),'k-o'); hold on;

% plot(timev2, V_HAW3v2,'k--o');
% plot(stimeO, V_HAW3O_smoothed,'k--o');

% plot(x3dg_time, x3dg_HAW3,'r','LineWidth',2);
% plot(sxtime, x3dg_smoothed,'r','LineWidth',2);

% plot(elmgTD_time, elmgTD_HAW3,'--r','LineWidth',2);
plot(setime, elmg_smoothed,'--r','LineWidth',2);

datetick('x',dateFormat); set(gca,'FontSize',16);
% legend('HAW3','ECCOv4r3','ECCO-GODAEi199','Location','southoutside','Orientation','horizontal')
legend('HAW3','ECCOv4r3-elmgTD','Location','southoutside','Orientation','horizontal') % 'ECCOv4r3-x3dg',
xlim([datenum('January 1 1997') datenum('September 1 2000')]);
xlabel('Year'); ylabel('Voltage (V)'); 

% print('HAW3/HAW3_90day_ECCOv4_elmgTD_hires_1997-2001','-dpng');
% print('HAW3/HAW3_30p5day_ECCOv4_elmgTD_hires_1997-2001','-dpng');
%%
[ h1, pred, ptime ] = F_corplot(HAW3_smoothed(14905:end), elmg_smoothed, stime3(14905:end), setime);
% 14905 or 17930
% F_corplot(HAW3_smoothed(17930:end), elmgTD_HAW3, stime3(17930:end), elmgTD_time)

%% Get correlation info

% condense the cable data
HAW3data= HAW3_smoothed(14905:end);
HAW3time= stime3(14905:end);

% first interpolate predictions to be as fine resolution as observation
predinterp = interp1(ptime,pred,HAW3time);

temp=isnan(predinterp);

predinterp(temp)=[];
HAW3time(temp)=[];
HAW3data(temp)=[];

[R,P] = corrcoef(HAW3data,predinterp)

%% Cable versus prediction correlation
clc
sp= datenum('January 1 1997');
ep= datenum('July 1 2000');
[ R, R2 ] = F_cablecor(HAW3_smoothed, elmg_smoothed, stime3, setime, sp, ep)
% [ R, R2 ] = F_cablecor(HAW3_smoothed, V_HAW3O_smoothed, stime3, stimeO, sp, ep)
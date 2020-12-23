% Compare the ECCO v2 and v4 transports
clc; clear all; close all;
load ECCO_1992-2015_Transports.mat
load ECCO_v2/IU-IV-Source-iter199.mat

%% Compare the cable transport in each model
t_HAW1_v4 = F_cablePred_transport(5);
t_HAW3_v4 = F_cablePred_transport(7);
t_OKI_v4 = F_cablePred_transport(2);

t_HAW1_v2 = F_cablePred_transportv2(5);
t_HAW3_v2 = F_cablePred_transportv2(7);
t_OKI_v2 = F_cablePred_transportv2(2);
%% plot the transports
close
figure(1); hold on;
plot(time, t_HAW1_v4/1e6,'LineWidth',2)
plot(time(1:length(t_HAW1_v2)), t_HAW1_v2/1e6,'k','LineWidth',2)
set(gca, 'FontSize', 18,'LineWidth',2);
ylabel('Transport [Sv]', 'FontSize', 20); 
datetick('x',12); xlabel('Date', 'FontSize', 20)
xlim([time(1) datenum('January 1 2005')]); 
grid on
title('HAW1', 'FontSize', 18); 
legend('ECCOv4r3','ECCO-GODAEi199','Location','southoutside','Orientation','horizontal')
print('Transport_ECCOv4-v2_HAW1', '-dpng')

%%
close
figure(1); hold on;
plot(time, t_HAW3_v4/1e6,'LineWidth',2)
plot(time(1:length(t_HAW3_v2)), t_HAW3_v2/1e6,'k','LineWidth',2)
set(gca, 'FontSize', 18,'LineWidth',2);
ylabel('Transport [Sv]', 'FontSize', 20); 
datetick('x',12); xlabel('Date', 'FontSize', 20)
xlim([time(1) datenum('January 1 2005')]);
grid on
title('HAW3', 'FontSize', 18); 
legend('ECCOv4r3','ECCO-GODAEi199','Location','southoutside','Orientation','horizontal')
print('Transport_ECCOv4-v2_HAW3', '-dpng')

%%
close
figure(1); hold on;
plot(time, t_OKI_v4/1e6,'LineWidth',2)
plot(time(1:length(t_OKI_v2)), t_OKI_v2/1e6,'k','LineWidth',2)
set(gca, 'FontSize', 18,'LineWidth',2);
ylabel('Transport [Sv]', 'FontSize', 20); 
datetick('x',12); xlabel('Date', 'FontSize', 20)
xlim([time(1) datenum('January 1 2005')]);
grid on
title('OKI', 'FontSize', 18); 
legend('ECCOv4r3','ECCO-GODAEi199','Location','southoutside','Orientation','horizontal')
print('Transport_ECCOv4-v2_OKI', '-dpng')

%% Plots
limits=size(IU1);

for i=1 % :limits(3)
    tempE2=flipud(reshape(IU1(:,:,i),[180 360]));
    tempN2=flipud(reshape(IV1(:,:,i),[180 360]));
    
    tempE4=reshape(transE(:,:,1),[180 360]);
    tempN4=reshape(transN(:,:,1),[180 360]);
    
    tempE4=[tempE4(:, 181:end) tempE4(:, 1:180)];
    tempN4=[tempN4(:, 181:end) tempN4(:, 1:180)];
    
    load coast;
    %%
    figure(1)
    subplot(121)
    imagesc(tempE4, [-200 200])
    set(gca, 'FontSize', 18);
    title('U v4')
    xlabel('Longitude (Degrees) '); ylabel('Colatitude (Degrees)');
    colormap(F_redblue);
    h=colorbar; set(h,'fontsize',14); set(get(h,'ylabel'),'string','m^2/s','fontsize',18);
    hold on; plot([long,360+long], (90-lat), '-k');
    
    subplot(122)
    imagesc(tempE2, [-200 200])
    set(gca, 'FontSize', 18);
    title('U v2')
    xlabel('Longitude (Degrees) '); ylabel('Colatitude (Degrees)');
    colormap(F_redblue);
    h=colorbar; set(h,'fontsize',14); set(get(h,'ylabel'),'string','m^2/s','fontsize',18);
    hold on; plot([long,360+long], (90-lat), '-k');
    
    figure(2)
    subplot(121)
    imagesc(tempN4, [-200 200])
    set(gca, 'FontSize', 18);
    title('V v4')
    xlabel('Longitude (Degrees) '); ylabel('Colatitude (Degrees)');
    colormap(F_redblue);
    h=colorbar; set(h,'fontsize',14); set(get(h,'ylabel'),'string','m^2/s','fontsize',18);
    hold on; plot([long,360+long], (90-lat), '-k');
    
    subplot(122)
    imagesc(tempN2, [-200 200])
    set(gca, 'FontSize', 18);
    title('V v2')
    xlabel('Longitude (Degrees) '); ylabel('Colatitude (Degrees)');
    colormap(F_redblue);
    h=colorbar; set(h,'fontsize',14); set(get(h,'ylabel'),'string','m^2/s','fontsize',18);
    hold on; plot([long,360+long], (90-lat), '-k');
    
    Ediff = tempE4 - tempE2;
    Ndiff = tempN4 - tempN2;
end

%%
close all
figure(1)
imagesc(Ediff, [-100 100])
hold on; plot([long,360+long], (90-lat), '-k');
line([(360-123.7) (360-158.2)],[(90-38.9) (90-21.5)],'Color','k') % HAW1
line([(360-120.7) (360-158.2)],[(90-35.3) (90-21.5)],'Color','k') % HAW3
line([(139.2) (127.9)],[(90-35.2) (90-26.5)],'Color','k') % OKI
set(gca, 'FontSize', 18);
title('U v4-v2')
xlabel('Longitude (Degrees) '); ylabel('Colatitude (Degrees)');
xlim([100 300]); ylim([30 80]);
colormap(F_redblue);
h=colorbar; set(h,'fontsize',14); set(get(h,'ylabel'),'string','m^2/s','fontsize',18);
% print('U_ECCOv4-v2', '-dpng')

figure(2)
imagesc(Ndiff, [-100 100])
hold on; plot([long,360+long], (90-lat), '-k');
line([(360-123.7) (360-158.2)],[(90-38.9) (90-21.5)],'Color','k') % HAW1
line([(360-120.7) (360-158.2)],[(90-35.3) (90-21.5)],'Color','k') % HAW3
line([(139.2) (127.9)],[(90-35.2) (90-26.5)],'Color','k') % OKI
set(gca, 'FontSize', 18);
title('V v4-v2')
xlabel('Longitude (Degrees) '); ylabel('Colatitude (Degrees)');
xlim([100 300]); ylim([30 80]);
colormap(F_redblue);
h=colorbar; set(h,'fontsize',14); set(get(h,'ylabel'),'string','m^2/s','fontsize',18);
% print('V_ECCOv4-v2', '-dpng')
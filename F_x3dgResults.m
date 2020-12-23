function [  ] = F_x3dgResults(x3dg, time, field)
% Create plots & a film of the electric field (E) or magnetic field (B) data across the timespan
%   INPUTS:
%   x3dg - the 3D x3dg results to be plotted (time vs lat vs lon)
%   time - the time stamp of each model prediction
%   field - string that is either 'E' or 'B' depending on which field
%   results are being examined
%   OUTPUTS:

%% load colormap
addpath /Users/neeshaschnepf/RESEARCH/Data/colormaps/

%% Make plots for movie
n=length(time);
images = cell(n,1);
for i=1:n; 
    t=time(i);
    picname=['Figures/ECCO_' field '_' datestr(t,29) '.png'];
    figure(1);
    temp=x3dg(i,:,:);
    temp=reshape(temp,[180,360]);
    imagesc(0:360,0:180,temp);
    c = redblue(20);
    colormap(c);
    
    set(gca, 'FontSize', 18);
    xlabel('Longitude (Degrees)');
    ylabel('Latitude (Degrees)');
    title(datestr(t,29));
    
    if field=='E'
     h=colorbar('peer',gca); caxis([-2 2]);
     set(h,'fontsize',14); set(get(h,'ylabel'),'string','Electric field (mV/Km)','fontsize',18);
    elseif field=='B'
     h=colorbar('peer',gca); caxis([-2 2]);
     set(h,'fontsize',14); set(get(h,'ylabel'),'string','Magnetic field (nT)','fontsize',18);   
    end
     
    load coast;
    hold on; plot([long,360+long], (90-lat), '-k','LineWidth',2);
    
    print(picname,'-dpng');
    % save the plot to make a movie
    images{i}=imread(picname); %imresize(A,outputSize)
end
%% make movie

disp('start making the movie!')

% create the video writer with 1 fps
writerObj = VideoWriter(['Figures/ECCO_' field '_1992-2004.avi']);
writerObj.FrameRate = 4;
% set the seconds per image
secsPerImage = ones(1,n);
% open the video writer
open(writerObj);
% write the frames to the video
for u=1:n
    % convert the image to a frame
    frame = im2frame(images{u});
    for v=1:secsPerImage(u)
        writeVideo(writerObj, frame);
    end
end
% close the writer object
close(writerObj);
disp('done ^__~')

end
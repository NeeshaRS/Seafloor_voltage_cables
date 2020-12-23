function [  ] = F_makeMovie(S, field, location)
% Create plots & a film of the electric field (E) or magnetic field (B) data across the timespan
%   INPUTS:
%   S - the list of names corresponding to the images for the movie
%   field - the 'E' or 'B' field
%   location - 'seafloor', 'sealevel', '430km' altitude
%   OUTPUTS:

% Load in plots for movie
n=length(S);
images = cell(n,1);
for i=1:n
    % save the plot to make a movie
    images{i}=imread(S(i).name); %imresize(A,outputSize)
end

% make movie
disp('start making the movie!')

% create the video writer with 1 fps
writerObj = VideoWriter(['ECCOx3dg_' field '_' location '_1992-2015.avi']);
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